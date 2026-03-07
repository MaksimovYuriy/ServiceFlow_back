class MaterialForecastController < ApplicationController
  def create
    MaterialForecastJob.perform_now
    render json: MaterialForecastResultService.new.call
  end

  def show
    render json: MaterialForecastResultService.new.call
  rescue MaterialForecastResultService::NotFound => e
    render json: { error: e.message }, status: :not_found
  end
end
