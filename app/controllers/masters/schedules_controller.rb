module Masters
  class SchedulesController < ApplicationController
    before_action :set_master

    def index
      render json: MasterScheduleService.new(@master).call
    end

    def create
      schedule = @master.master_schedules.create!(schedule_params)
      render json: schedule, status: :created
    end

    def destroy
      @master.master_schedules.find(params[:id]).destroy!
      head :no_content
    end

    private

    def set_master
      @master = Master.find(params[:master_id])
    end

    def schedule_params
      params.permit(:weekday, :start_time, :end_time)
    end
  end
end
