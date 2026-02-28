class PriceAnalysisJob < ApplicationJob
  queue_as :default

  def perform
    PriceAnalysisService.new.call
  end
end
