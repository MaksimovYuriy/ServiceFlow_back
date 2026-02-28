class PriceAnalysisController < ApplicationController
  PREDICTIONS_PATH = Rails.root.join('tmp', 'price_predictions.json')

  def create
    PriceAnalysisJob.perform_now
    predictions = JSON.parse(File.read(PREDICTIONS_PATH))
    service_titles = Service.where(id: predictions.map { |p| p['service_id'] }).pluck(:id, :title).to_h
    predictions.each { |p| p['service_title'] = service_titles[p['service_id']] }
    render json: { predictions: predictions }
  end

  def show
    unless File.exist?(PREDICTIONS_PATH)
      return render json: { error: 'No predictions yet' }, status: :not_found
    end

    predictions = JSON.parse(File.read(PREDICTIONS_PATH))
    service_titles = Service.where(id: predictions.map { |p| p['service_id'] }).pluck(:id, :title).to_h

    predictions.each do |p|
      p['service_title'] = service_titles[p['service_id']]
    end

    render json: { predictions: predictions }
  end
end
