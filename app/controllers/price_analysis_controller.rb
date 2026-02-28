class PriceAnalysisController < ApplicationController
  PREDICTIONS_PATH = Rails.root.join('tmp', 'price_predictions.json')

  def create
    PriceAnalysisJob.perform_later
    render json: { status: 'started' }, status: :accepted
  end

  def show
    unless File.exist?(PREDICTIONS_PATH)
      return render json: { error: 'No predictions yet' }, status: :not_found
    end

    predictions = JSON.parse(File.read(PREDICTIONS_PATH))
    render json: { predictions: predictions }
  end
end
