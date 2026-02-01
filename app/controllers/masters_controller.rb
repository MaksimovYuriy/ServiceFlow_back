class MastersController < ApplicationController
  skip_before_action :authenticate!, only: [:index, :available_dates, :available_slots]

  def index
    masters = MasterResource.all(params)
    respond_with(masters)
  end

  def show
    master = MasterResource.find(params)
    respond_with(master)
  end

  def create
    master = MasterResource.build(params)

    if master.save
      render jsonapi: master, status: 201
    else
      render jsonapi_errors: master
    end
  end

  def update
    master = MasterResource.find(params)

    if master.update_attributes
      render jsonapi: master
    else
      render jsonapi_errors: master
    end
  end

  def destroy
    master = MasterResource.find(params)

    if master.destroy
      render jsonapi: { meta: {} }, status: 200
    else
      render jsonapi_errors: master
    end
  end

  def available_dates
    master = Master.find(params[:id])
    dates = MasterScheduleService.new(master).available_dates(30)
    render json: dates
  end

  def available_slots
    master = Master.find(params[:id])
    date = params[:date].to_date
    slots = MasterScheduleService.new(master).available_slots(date)
    render json: slots
  end
end
