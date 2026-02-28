import os
import json
import numpy as np
import pandas as pd
import torch
import torch.nn as nn

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(SCRIPT_DIR, '..', 'tmp', 'price_analysis.csv')
MODEL_PATH = os.path.join(SCRIPT_DIR, 'model.pth')
OUTPUT_PATH = os.path.join(SCRIPT_DIR, '..', 'tmp', 'price_predictions.json')


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


def predict():
    checkpoint = torch.load(MODEL_PATH, weights_only=False)

    model = PriceMLP(checkpoint['input_size'], checkpoint['hidden_sizes'])
    model.load_state_dict(checkpoint['model_state'])
    model.eval()

    mean = np.array(checkpoint['feature_mean'], dtype=np.float32)
    std = np.array(checkpoint['feature_std'], dtype=np.float32)
    features = checkpoint['features']

    df = pd.read_csv(CSV_PATH)
    df['month_sin'] = np.sin(2 * np.pi * df['month'] / 12)
    df['month_cos'] = np.cos(2 * np.pi * df['month'] / 12)

    # Use only the latest year for prediction
    max_year = int(df['year'].max())
    df_predict = df[df['year'] == max_year]
    df_train = df[df['year'] < max_year]
    print(f'Predicting on {len(df_predict)} rows ({max_year})')

    # Median bookings from training period for "unpopular" threshold
    median_bookings = df_train.groupby('service_id')['total_bookings'].mean().median()

    results = []

    for service_id in sorted(df_predict['service_id'].unique()):
        sdf = df_predict[df_predict['service_id'] == service_id]

        base_price = float(sdf['base_price'].iloc[-1])
        is_active = int(sdf['is_active'].iloc[-1])

        # Average 2026 features as model input
        X = sdf[features].mean().values.astype(np.float32)
        X_norm = (X - mean) / std

        with torch.no_grad():
            price_ratio = model(torch.tensor(X_norm).unsqueeze(0)).item()

        suggested = base_price * price_ratio

        # Clamp +-15%
        suggested = max(base_price * 0.85, min(base_price * 1.15, suggested))

        # -5% for unpopular services (avg bookings in 2026 < half of historical median)
        avg_bookings = sdf['total_bookings'].mean()
        if avg_bookings < median_bookings * 0.5:
            suggested *= 0.95
            suggested = max(base_price * 0.85, suggested)

        results.append({
            'service_id': int(service_id),
            'current_price': base_price,
            'suggested_price': round(suggested, 2),
            'difference': round(suggested - base_price, 2),
            'difference_pct': round((suggested - base_price) / base_price * 100, 1),
            'is_active': is_active,
        })

    with open(OUTPUT_PATH, 'w') as f:
        json.dump(results, f, indent=2, ensure_ascii=False)

    print(f'Predictions saved to {OUTPUT_PATH}')
    print(f'{len(results)} services processed')


if __name__ == '__main__':
    predict()
