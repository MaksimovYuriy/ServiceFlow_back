import json
import os
import numpy as np
import pandas as pd
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(SCRIPT_DIR, '..', 'tmp', 'price_analysis.csv')
MODEL_PATH = os.path.join(SCRIPT_DIR, 'price_model.pth')
METRICS_PATH = os.path.join(SCRIPT_DIR, '..', 'tmp', 'price_metrics.json')

FEATURES = [
    'base_price', 'is_active', 'total_bookings', 'revenue',
    'avg_price_fact', 'first_visit_share', 'month_sin', 'month_cos',
    'avg_material_cost_per_service', 'material_cost_share',
]

EPOCHS = 1000
LR = 0.001
BATCH_SIZE = 32
HIDDEN_SIZES = [64, 32, 16]
DROPOUT = 0.1
TEST_MONTHS = 3
VAL_MONTHS = 3


class PriceMLP(nn.Module):
    def __init__(self, input_size, hidden_sizes, dropout=0.1):
        super().__init__()
        layers = []
        prev = input_size
        for h in hidden_sizes:
            layers.append(nn.Linear(prev, h))
            layers.append(nn.ReLU())
            layers.append(nn.Dropout(dropout))
            prev = h
        layers.append(nn.Linear(prev, 1))
        self.net = nn.Sequential(*layers)

    def forward(self, x):
        return self.net(x)


def prepare_features(df):
    df = df.copy()
    df['month_sin'] = np.sin(2 * np.pi * df['month'] / 12)
    df['month_cos'] = np.cos(2 * np.pi * df['month'] / 12)
    df['price_ratio'] = df['target_price'] / df['base_price']
    return df


def temporal_split(df, val_months, test_months):
    df = df.sort_values(['year', 'month']).reset_index(drop=True)
    df = df.assign(ym=df['year'] * 12 + df['month'])

    unique_ym = sorted(df['ym'].unique())
    if len(unique_ym) < val_months + test_months + 1:
        raise RuntimeError(
            f'Not enough months for temporal split: have {len(unique_ym)}, '
            f'need at least {val_months + test_months + 1}'
        )

    test_start = unique_ym[-test_months]
    val_start = unique_ym[-(test_months + val_months)]

    train_df = df[df['ym'] < val_start]
    val_df = df[(df['ym'] >= val_start) & (df['ym'] < test_start)]
    test_df = df[df['ym'] >= test_start]
    return train_df, val_df, test_df


def compute_metrics(y_true, y_pred):
    y_true = np.asarray(y_true).reshape(-1)
    y_pred = np.asarray(y_pred).reshape(-1)
    err = y_true - y_pred
    mse = float((err ** 2).mean())
    mae = float(np.abs(err).mean())
    denom = float(np.abs(y_true).sum())
    wmape = float(np.abs(err).sum() / denom * 100) if denom > 0 else 0.0
    return mse, mae, wmape


def train():
    df = pd.read_csv(CSV_PATH)
    df = prepare_features(df)

    max_year = int(df['year'].max())
    train_pool = df[df['year'] < max_year]
    predict_pool = df[df['year'] == max_year]
    print(
        f'Total rows: {len(df)} | training pool (year<{max_year}): {len(train_pool)} | '
        f'prediction pool (year={max_year}): {len(predict_pool)}'
    )

    train_df, val_df, test_df = temporal_split(train_pool, VAL_MONTHS, TEST_MONTHS)
    print(f'Train: {len(train_df)} rows | Val: {len(val_df)} rows | Test: {len(test_df)} rows')

    X_train = train_df[FEATURES].values.astype(np.float32)
    y_train = train_df['price_ratio'].values.astype(np.float32).reshape(-1, 1)
    X_val = val_df[FEATURES].values.astype(np.float32)
    y_val = val_df['price_ratio'].values.astype(np.float32).reshape(-1, 1)
    X_test = test_df[FEATURES].values.astype(np.float32)
    y_test = test_df['price_ratio'].values.astype(np.float32).reshape(-1, 1)

    mean = X_train.mean(axis=0)
    std = X_train.std(axis=0)
    std[std == 0] = 1

    X_train_n = (X_train - mean) / std
    X_val_n = (X_val - mean) / std
    X_test_n = (X_test - mean) / std

    train_dl = DataLoader(
        TensorDataset(torch.tensor(X_train_n), torch.tensor(y_train)),
        batch_size=BATCH_SIZE, shuffle=True,
    )

    model = PriceMLP(len(FEATURES), HIDDEN_SIZES, dropout=DROPOUT)
    optimizer = torch.optim.Adam(model.parameters(), lr=LR)
    criterion = nn.MSELoss()

    best_val_loss = float('inf')
    best_state = None

    X_val_t = torch.tensor(X_val_n)
    y_val_t = torch.tensor(y_val)

    for epoch in range(EPOCHS):
        model.train()
        for xb, yb in train_dl:
            pred = model(xb)
            loss = criterion(pred, yb)
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

        if (epoch + 1) % 50 == 0:
            model.eval()
            with torch.no_grad():
                val_loss = criterion(model(X_val_t), y_val_t).item()

            if val_loss < best_val_loss:
                best_val_loss = val_loss
                best_state = {k: v.clone() for k, v in model.state_dict().items()}

            if (epoch + 1) % 200 == 0:
                print(f'  Epoch {epoch+1}/{EPOCHS}  val_loss={val_loss:.6f}  best={best_val_loss:.6f}')

    model.load_state_dict(best_state)
    model.eval()
    with torch.no_grad():
        test_pred = model(torch.tensor(X_test_n)).numpy()

    mse, mae, wmape = compute_metrics(y_test, test_pred)

    baseline_pred = np.ones_like(y_test)
    b_mse, b_mae, b_wmape = compute_metrics(y_test, baseline_pred)

    improvement_mae = (b_mae - mae) / b_mae * 100 if b_mae > 0 else 0.0

    print('\n=== Test metrics (price_ratio) ===')
    print(f'MLP   : MSE={mse:.6f}  MAE={mae:.6f}  wMAPE={wmape:.2f}%')
    print(f'Naive : MSE={b_mse:.6f}  MAE={b_mae:.6f}  wMAPE={b_wmape:.2f}%   (predicted_ratio = 1.0)')
    print(f'MAE improvement vs naive baseline: {improvement_mae:+.1f}%')

    metrics = {
        'best_val_loss': best_val_loss,
        'test_mse': mse,
        'test_mae': mae,
        'test_wmape': wmape,
        'baseline_mse': b_mse,
        'baseline_mae': b_mae,
        'baseline_wmape': b_wmape,
        'mae_improvement_pct': improvement_mae,
        'train_rows': len(train_df),
        'val_rows': len(val_df),
        'test_rows': len(test_df),
    }

    torch.save({
        'model_state': best_state,
        'input_size': len(FEATURES),
        'hidden_sizes': HIDDEN_SIZES,
        'dropout': DROPOUT,
        'feature_mean': mean.tolist(),
        'feature_std': std.tolist(),
        'features': FEATURES,
        'metrics': metrics,
    }, MODEL_PATH)

    with open(METRICS_PATH, 'w') as f:
        json.dump(metrics, f, indent=2, ensure_ascii=False)

    print(f'\nModel saved to {MODEL_PATH}')
    print(f'Metrics saved to {METRICS_PATH}')


if __name__ == '__main__':
    train()
