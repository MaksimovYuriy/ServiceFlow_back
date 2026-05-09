import json
import os
import numpy as np
import pandas as pd
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(SCRIPT_DIR, '..', 'tmp', 'material_forecast.csv')
MODEL_PATH = os.path.join(SCRIPT_DIR, 'material_model.pth')
METRICS_PATH = os.path.join(SCRIPT_DIR, '..', 'tmp', 'material_metrics.json')

FEATURES = [
    'bookings_lag_1', 'bookings_lag_2', 'bookings_lag_3',
    'avg_bookings_last_3m', 'usage_trend',
    'month_sin', 'month_cos',
]

TARGET = 'booking_ratio'

EPOCHS = 1500
LR = 0.001
BATCH_SIZE = 32
HIDDEN_SIZES = [32, 16]
DROPOUT = 0.1


def compute_metrics(y_true, y_pred):
    y_true = np.asarray(y_true).reshape(-1)
    y_pred = np.asarray(y_pred).reshape(-1)
    err = y_true - y_pred
    mse = float((err ** 2).mean())
    mae = float(np.abs(err).mean())
    denom = float(np.abs(y_true).sum())
    wmape = float(np.abs(err).sum() / denom * 100) if denom > 0 else 0.0
    return mse, mae, wmape


class MaterialMLP(nn.Module):
    def __init__(self, input_size, hidden_sizes):
        super().__init__()
        layers = []
        prev = input_size
        for h in hidden_sizes:
            layers.append(nn.Linear(prev, h))
            layers.append(nn.ReLU())
            layers.append(nn.Dropout(0.1))
            prev = h
        layers.append(nn.Linear(prev, 1))
        self.net = nn.Sequential(*layers)

    def forward(self, x):
        return self.net(x)


def train():
    df = pd.read_csv(CSV_PATH)

    # Temporal split: train on all except last 6 months, val = months -6 to -3, test = last 3
    df = df.sort_values(['service_id', 'year', 'month']).reset_index(drop=True)

    max_year = int(df['year'].max())
    max_month = int(df[df['year'] == max_year]['month'].max())

    # Calculate cutoff dates
    # Test: last 3 months
    # Val: 3 months before test
    test_cutoff = (max_year, max_month - 2) if max_month > 2 else (max_year - 1, max_month + 10)
    val_cutoff_month = test_cutoff[1] - 3
    val_cutoff = (test_cutoff[0], val_cutoff_month) if val_cutoff_month > 0 else (test_cutoff[0] - 1, val_cutoff_month + 12)

    def year_month_key(row):
        return row['year'] * 12 + row['month']

    df['ym'] = df.apply(year_month_key, axis=1)
    test_ym = test_cutoff[0] * 12 + test_cutoff[1]
    val_ym = val_cutoff[0] * 12 + val_cutoff[1]

    train_df = df[df['ym'] < val_ym]
    val_df = df[(df['ym'] >= val_ym) & (df['ym'] < test_ym)]
    test_df = df[df['ym'] >= test_ym]

    print(f'Train: {len(train_df)} rows')
    print(f'Val:   {len(val_df)} rows')
    print(f'Test:  {len(test_df)} rows')

    X_train = train_df[FEATURES].values.astype(np.float32)
    y_train = train_df[TARGET].values.astype(np.float32).reshape(-1, 1)

    X_val = val_df[FEATURES].values.astype(np.float32)
    y_val = val_df[TARGET].values.astype(np.float32).reshape(-1, 1)

    X_test = test_df[FEATURES].values.astype(np.float32)
    y_test = test_df[TARGET].values.astype(np.float32).reshape(-1, 1)

    # Normalize using training stats
    mean = X_train.mean(axis=0)
    std = X_train.std(axis=0)
    std[std == 0] = 1

    X_train_norm = (X_train - mean) / std
    X_val_norm = (X_val - mean) / std
    X_test_norm = (X_test - mean) / std

    train_dl = DataLoader(
        TensorDataset(torch.tensor(X_train_norm), torch.tensor(y_train)),
        batch_size=BATCH_SIZE, shuffle=True,
    )

    model = MaterialMLP(len(FEATURES), HIDDEN_SIZES)
    optimizer = torch.optim.Adam(model.parameters(), lr=LR)
    criterion = nn.MSELoss()

    best_val_loss = float('inf')
    best_state = None

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
                val_pred = model(torch.tensor(X_val_norm))
                val_loss = criterion(val_pred, torch.tensor(y_val)).item()

            if val_loss < best_val_loss:
                best_val_loss = val_loss
                best_state = {k: v.clone() for k, v in model.state_dict().items()}

            if (epoch + 1) % 300 == 0:
                print(f'  Epoch {epoch+1}/{EPOCHS}  val_loss={val_loss:.6f}  best={best_val_loss:.6f}')

    model.load_state_dict(best_state)
    model.eval()
    with torch.no_grad():
        test_pred = model(torch.tensor(X_test_norm)).numpy()

    mse, mae, wmape = compute_metrics(y_test, test_pred)

    baseline_lag1_pred = test_df['bookings_lag_1'].values.astype(np.float32)
    baseline_avg3_pred = test_df['avg_bookings_last_3m'].values.astype(np.float32)

    lag1_mse, lag1_mae, lag1_wmape = compute_metrics(y_test, baseline_lag1_pred)
    avg3_mse, avg3_mae, avg3_wmape = compute_metrics(y_test, baseline_avg3_pred)

    best_baseline_mae = min(lag1_mae, avg3_mae)
    improvement_mae = (best_baseline_mae - mae) / best_baseline_mae * 100 if best_baseline_mae > 0 else 0.0

    print('\n=== Test metrics (booking_ratio) ===')
    print(f'MLP        : MSE={mse:.6f}  MAE={mae:.6f}  wMAPE={wmape:.2f}%')
    print(f'Naive lag1 : MSE={lag1_mse:.6f}  MAE={lag1_mae:.6f}  wMAPE={lag1_wmape:.2f}%   (predicted = previous month ratio)')
    print(f'Avg 3m     : MSE={avg3_mse:.6f}  MAE={avg3_mae:.6f}  wMAPE={avg3_wmape:.2f}%   (predicted = mean of last 3 months)')
    print(f'MAE improvement vs best baseline: {improvement_mae:+.1f}%')

    metrics = {
        'best_val_loss': best_val_loss,
        'test_mse': mse,
        'test_mae': mae,
        'test_wmape': wmape,
        'baseline_lag1_mae': lag1_mae,
        'baseline_lag1_wmape': lag1_wmape,
        'baseline_avg3_mae': avg3_mae,
        'baseline_avg3_wmape': avg3_wmape,
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
