import os
import numpy as np
import pandas as pd
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(SCRIPT_DIR, '..', 'tmp', 'price_analysis.csv')
MODEL_PATH = os.path.join(SCRIPT_DIR, 'price_model.pth')

FEATURES = [
    'base_price', 'is_active', 'total_bookings', 'revenue',
    'avg_price_fact', 'first_visit_share', 'month_sin', 'month_cos',
    'avg_material_cost_per_service', 'material_cost_share',
]

EPOCHS = 1000
LR = 0.001
BATCH_SIZE = 32
HIDDEN_SIZES = [64, 32, 16]


class PriceMLP(nn.Module):
    def __init__(self, input_size, hidden_sizes):
        super().__init__()
        layers = []
        prev = input_size
        for h in hidden_sizes:
            layers.append(nn.Linear(prev, h))
            layers.append(nn.ReLU())
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


def train():
    df = pd.read_csv(CSV_PATH)
    df = prepare_features(df)

    # Train on all years except the latest (held out for prediction)
    max_year = int(df['year'].max())
    train_df = df[df['year'] < max_year]
    predict_df = df[df['year'] == max_year]
    print(f'Training on {len(train_df)} rows (up to {max_year - 1})')
    print(f'Held out {len(predict_df)} rows ({max_year}) for prediction')

    X = train_df[FEATURES].values.astype(np.float32)
    y = train_df['price_ratio'].values.astype(np.float32).reshape(-1, 1)

    # Normalize on training data only
    mean = X.mean(axis=0)
    std = X.std(axis=0)
    std[std == 0] = 1
    X_norm = (X - mean) / std

    # 80/20 validation split within 2024-2025
    n = len(X_norm)
    indices = np.random.permutation(n)
    split = int(0.8 * n)
    train_idx, val_idx = indices[:split], indices[split:]

    X_train = torch.tensor(X_norm[train_idx])
    y_train = torch.tensor(y[train_idx])
    X_val = torch.tensor(X_norm[val_idx])
    y_val = torch.tensor(y[val_idx])

    train_dl = DataLoader(
        TensorDataset(X_train, y_train),
        batch_size=BATCH_SIZE, shuffle=True,
    )

    model = PriceMLP(len(FEATURES), HIDDEN_SIZES)
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
                val_pred = model(X_val)
                val_loss = criterion(val_pred, y_val).item()

            if val_loss < best_val_loss:
                best_val_loss = val_loss
                best_state = {k: v.clone() for k, v in model.state_dict().items()}

            if (epoch + 1) % 200 == 0:
                print(f'  Epoch {epoch+1}/{EPOCHS}  val_loss={val_loss:.8f}  best={best_val_loss:.8f}')

    torch.save({
        'model_state': best_state,
        'input_size': len(FEATURES),
        'hidden_sizes': HIDDEN_SIZES,
        'feature_mean': mean.tolist(),
        'feature_std': std.tolist(),
        'features': FEATURES,
    }, MODEL_PATH)

    print(f'\nModel saved to {MODEL_PATH}')
    print(f'Best validation loss: {best_val_loss:.8f}')


if __name__ == '__main__':
    train()
