class MaterialForecastResultService
  PREDICTIONS_PATH = Rails.root.join('tmp', 'material_predictions.json')

  class NotFound < StandardError; end

  def call
    raise NotFound, 'No predictions yet' unless File.exist?(PREDICTIONS_PATH)

    predictions = JSON.parse(File.read(PREDICTIONS_PATH))

    {
      predictions: predictions,
      summary: {
        total_materials: predictions.size,
        need_purchase: predictions.count { |p| p['purchase_qty'] > 0 },
        total_cost: predictions.sum { |p| p['purchase_cost'] },
        forecast_months: 3
      }
    }
  end
end
