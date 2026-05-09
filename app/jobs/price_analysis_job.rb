require 'open3'

class PriceAnalysisJob < ApplicationJob
  queue_as :default

  VENV_PYTHON      = Rails.root.join('ml', 'venv', 'bin', 'python3').to_s
  TRAIN_SCRIPT     = Rails.root.join('ml', 'train_price.py').to_s
  PREDICT_SCRIPT   = Rails.root.join('ml', 'predict_price.py').to_s
  PREDICTIONS_PATH = Rails.root.join('tmp', 'price_predictions.json')
  METRICS_PATH     = Rails.root.join('tmp', 'price_metrics.json')

  def perform(price_prediction_id)
    record = PricePrediction.find(price_prediction_id)
    record.update!(status: :running, started_at: Time.current)

    PriceAnalysisService.new.call
    run_script(TRAIN_SCRIPT)
    run_script(PREDICT_SCRIPT)

    predictions = JSON.parse(File.read(PREDICTIONS_PATH))
    enrich_with_titles(predictions)

    metrics = File.exist?(METRICS_PATH) ? JSON.parse(File.read(METRICS_PATH)) : {}

    record.update!(
      status:       :completed,
      finished_at:  Time.current,
      predictions:  predictions,
      metrics:      metrics
    )
  rescue StandardError => e
    record&.update!(
      status:        :failed,
      finished_at:   Time.current,
      error_message: "#{e.class}: #{e.message}"
    )
    Rails.logger.error("PriceAnalysisJob failed: #{e.class}: #{e.message}")
  end

  private

  def run_script(script)
    output, status = Open3.capture2e(VENV_PYTHON, script)
    Rails.logger.info(output)
    raise "#{File.basename(script)} failed: #{output}" unless status.success?
  end

  def enrich_with_titles(predictions)
    ids    = predictions.map { |p| p['service_id'] }
    titles = Service.where(id: ids).pluck(:id, :title).to_h
    predictions.each { |p| p['service_title'] = titles[p['service_id']] }
  end
end
