import os
import json
import numpy as np
import pandas as pd
import torch
import torch.nn as nn

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(SCRIPT_DIR, '..', 'tmp', 'material_forecast.csv')
MODEL_PATH = os.path.join(SCRIPT_DIR, 'material_model.pth')
OUTPUT_PATH = os.path.join(SCRIPT_DIR, '..', 'tmp', 'material_predictions.json')
SERVICE_MATERIALS_PATH = os.path.join(SCRIPT_DIR, '..', 'tmp', 'service_materials.json')
MATERIALS_PATH = os.path.join(SCRIPT_DIR, '..', 'tmp', 'materials.json')

PREDICT_MONTHS = 3


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


def predict():
    checkpoint = torch.load(MODEL_PATH, weights_only=False)

    model = MaterialMLP(checkpoint['input_size'], checkpoint['hidden_sizes'])
    model.load_state_dict(checkpoint['model_state'])
    model.eval()

    mean = np.array(checkpoint['feature_mean'], dtype=np.float32)
    std = np.array(checkpoint['feature_std'], dtype=np.float32)
    features = checkpoint['features']

    df = pd.read_csv(CSV_PATH)

    # Load service_materials and materials info (exported by Rails)
    with open(SERVICE_MATERIALS_PATH) as f:
        service_materials = json.load(f)

    with open(MATERIALS_PATH) as f:
        materials = {m['id']: m for m in json.load(f)}

    # Determine last month in data
    max_ym = df[['year', 'month']].drop_duplicates().sort_values(['year', 'month']).iloc[-1]
    last_year, last_month = int(max_ym['year']), int(max_ym['month'])

    # Generate predictions for next PREDICT_MONTHS months
    service_ids = sorted(df['service_id'].unique())
    service_avg_bookings = df.groupby('service_id')['avg_bookings'].first().to_dict()

    # Collect per-service monthly predictions
    service_predictions = {}  # service_id -> [predicted_bookings_month_1, ...]

    for service_id in service_ids:
        sdf = df[df['service_id'] == service_id].sort_values(['year', 'month']).reset_index(drop=True)
        avg_b = service_avg_bookings[service_id]

        monthly_predictions = []

        # Build rolling history: start with actual data, append predictions
        ratios = sdf['booking_ratio'].tolist()

        for i in range(PREDICT_MONTHS):
            # Next month
            nm = last_month + i + 1
            ny = last_year + (nm - 1) // 12
            nm = ((nm - 1) % 12) + 1

            n = len(ratios)
            lag_1 = ratios[n - 1] if n >= 1 else 1.0
            lag_2 = ratios[n - 2] if n >= 2 else 1.0
            lag_3 = ratios[n - 3] if n >= 3 else 1.0
            avg_last_3m = (lag_1 + lag_2 + lag_3) / 3.0

            # Trend: last 3 / previous 3
            if n >= 6:
                recent = sum(ratios[n - 3:n]) / 3.0
                prev = sum(ratios[n - 6:n - 3]) / 3.0
                trend = recent / prev if prev > 0 else 1.0
            else:
                trend = 1.0

            month_sin = np.sin(2 * np.pi * nm / 12.0)
            month_cos = np.cos(2 * np.pi * nm / 12.0)

            x = np.array([lag_1, lag_2, lag_3, avg_last_3m, trend,
                          month_sin, month_cos], dtype=np.float32)
            x_norm = (x - mean) / std

            with torch.no_grad():
                pred_ratio = model(torch.tensor(x_norm).unsqueeze(0)).item()

            # Clamp to reasonable range
            pred_ratio = max(0.3, min(2.0, pred_ratio))
            ratios.append(pred_ratio)

            pred_bookings = max(0, round(pred_ratio * avg_b))
            monthly_predictions.append({
                'month': nm,
                'year': ny,
                'predicted_bookings': pred_bookings,
            })

        service_predictions[service_id] = monthly_predictions

    # Calculate material needs
    # service_materials: [{"service_id": 1, "material_id": 2, "required_quantity": 3}, ...]
    results = []

    for mat_id, mat in materials.items():
        months_detail = []

        for month_idx in range(PREDICT_MONTHS):
            month_usage = 0
            for sm in service_materials:
                if sm['material_id'] != mat_id:
                    continue
                sid = sm['service_id']
                if sid not in service_predictions:
                    continue
                pred = service_predictions[sid][month_idx]
                month_usage += pred['predicted_bookings'] * sm['required_quantity']

            nm = last_month + month_idx + 1
            ny = last_year + (nm - 1) // 12
            nm = ((nm - 1) % 12) + 1

            months_detail.append({
                'month': nm,
                'year': ny,
                'predicted_usage': month_usage,
            })

        total_usage = sum(m['predicted_usage'] for m in months_detail)
        purchase_qty = max(0, total_usage + mat['minimal_quantity'] - mat['current_quantity'])
        purchase_cost = round(purchase_qty * mat['price'], 2)

        results.append({
            'material_id': mat_id,
            'title': mat['title'],
            'current_quantity': mat['current_quantity'],
            'minimal_quantity': mat['minimal_quantity'],
            'unit_price': mat['price'],
            'months': months_detail,
            'total_predicted_usage': total_usage,
            'purchase_qty': purchase_qty,
            'purchase_cost': purchase_cost,
        })

    # Sort: materials needing purchase first, then by cost desc
    results.sort(key=lambda r: (-min(1, r['purchase_qty']), -r['purchase_cost']))

    with open(OUTPUT_PATH, 'w') as f:
        json.dump(results, f, indent=2, ensure_ascii=False)

    print(f'Predictions saved to {OUTPUT_PATH}')
    print(f'{len(results)} materials processed')

    # Summary
    total_cost = sum(r['purchase_cost'] for r in results)
    need_purchase = sum(1 for r in results if r['purchase_qty'] > 0)
    print(f'\nMaterials needing purchase: {need_purchase}/{len(results)}')
    print(f'Total purchase cost: {total_cost:.2f}')


if __name__ == '__main__':
    predict()
