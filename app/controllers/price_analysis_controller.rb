class PriceAnalysisController < ApplicationController
  def create
    PriceAnalysisJob.perform_later
    render json: { status: 'started' }, status: :accepted
  end
end
