class PriceAnalysisResultService
  PREDICTIONS_PATH = Rails.root.join('tmp', 'price_predictions.json')

  class NotFound < StandardError; end

  def call
    raise NotFound, 'No predictions yet' unless File.exist?(PREDICTIONS_PATH)

    predictions = JSON.parse(File.read(PREDICTIONS_PATH))
    enrich_with_titles(predictions)

    { predictions: predictions }
  end

  private

  def enrich_with_titles(predictions)
    ids = predictions.map { |p| p['service_id'] }
    titles = Service.where(id: ids).pluck(:id, :title).to_h
    predictions.each { |p| p['service_title'] = titles[p['service_id']] }
  end
end
