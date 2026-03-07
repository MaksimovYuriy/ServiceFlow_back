class PriceAnalysisController < ApplicationController
  def create
    PriceAnalysisJob.perform_now
    render json: PriceAnalysisResultService.new.call
  end

  def show
    render json: PriceAnalysisResultService.new.call
  rescue PriceAnalysisResultService::NotFound => e
    render json: { error: e.message }, status: :not_found
  end
end
