module Api
  class AnalyticsController < ApplicationController
    def summary
      render json: Analytics::SummaryService.call(period)
    end

    def revenue
      render json: Analytics::RevenueService.call(period)
    end

    def masters
      render json: Analytics::MastersService.call(period)
    end

    def services
      render json: Analytics::ServicesService.call(period)
    end

    def clients
      render json: Analytics::ClientsService.call(period)
    end

    def materials
      render json: Analytics::MaterialsService.call(period)
    end

    private

    def period
      from = params[:from].present? ? Date.parse(params[:from]) : 12.months.ago.to_date.beginning_of_month
      to   = params[:to].present?   ? Date.parse(params[:to])   : Date.today

      from.beginning_of_month.beginning_of_day..to.end_of_month.end_of_day
    rescue Date::Error
      12.months.ago.beginning_of_month.beginning_of_day..Date.today.end_of_month.end_of_day
    end
  end
end
