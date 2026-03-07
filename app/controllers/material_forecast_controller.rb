class MaterialForecastController < ApplicationController
  PREDICTIONS_PATH = Rails.root.join('tmp', 'material_predictions.json')

  def create
    MaterialForecastJob.perform_now
    render_predictions
  end

  def show
    unless File.exist?(PREDICTIONS_PATH)
      return render json: { error: 'No predictions yet' }, status: :not_found
    end

    render_predictions
  end

  private

  def render_predictions
    predictions = JSON.parse(File.read(PREDICTIONS_PATH))
    total_cost = predictions.sum { |p| p['purchase_cost'] }

    render json: {
      predictions: predictions,
      summary: {
        total_materials: predictions.size,
        need_purchase: predictions.count { |p| p['purchase_qty'] > 0 },
        total_cost: total_cost,
        forecast_months: 3
      }
    }
  end
end
