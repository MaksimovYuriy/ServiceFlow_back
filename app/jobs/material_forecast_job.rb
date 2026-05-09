require 'open3'

class MaterialForecastJob < ApplicationJob
  queue_as :default

  VENV_PYTHON      = Rails.root.join('ml', 'venv', 'bin', 'python3').to_s
  TRAIN_SCRIPT     = Rails.root.join('ml', 'train_materials.py').to_s
  PREDICT_SCRIPT   = Rails.root.join('ml', 'predict_materials.py').to_s
  PREDICTIONS_PATH = Rails.root.join('tmp', 'material_predictions.json')
  METRICS_PATH     = Rails.root.join('tmp', 'material_metrics.json')

  def perform(material_prediction_id)
    record = MaterialPrediction.find(material_prediction_id)
    record.update!(status: :running, started_at: Time.current)

    MaterialForecastService.new.call
    run_script(TRAIN_SCRIPT)
    run_script(PREDICT_SCRIPT)

    predictions = JSON.parse(File.read(PREDICTIONS_PATH))
    summary = build_summary(predictions)

    metrics = File.exist?(METRICS_PATH) ? JSON.parse(File.read(METRICS_PATH)) : {}

    record.update!(
      status:       :completed,
      finished_at:  Time.current,
      predictions:  predictions,
      summary:      summary,
      metrics:      metrics
    )
  rescue StandardError => e
    record&.update!(
      status:        :failed,
      finished_at:   Time.current,
      error_message: "#{e.class}: #{e.message}"
    )
    Rails.logger.error("MaterialForecastJob failed: #{e.class}: #{e.message}")
  end

  private

  def run_script(script)
    output, status = Open3.capture2e(VENV_PYTHON, script)
    Rails.logger.info(output)
    raise "#{File.basename(script)} failed: #{output}" unless status.success?
  end

  def build_summary(predictions)
    {
      total_materials: predictions.size,
      need_purchase:   predictions.count { |p| p['purchase_qty'] > 0 },
      total_cost:      predictions.sum { |p| p['purchase_cost'] },
      forecast_months: 3
    }
  end
end
