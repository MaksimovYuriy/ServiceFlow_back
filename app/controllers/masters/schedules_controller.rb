module Masters
    class SchedulesController < ApplicationController
        before_action :set_master
        before_action :set_schedule, only: :destroy

        def index
            schedules = @master.master_schedules.order(:weekday, :start_time)

            render json: schedules.map { |s|
                {
                    id: s.id,
                    weekday: s.weekday,
                    start_time: s.start_time_hh_mm,
                    end_time: s.end_time_hh_mm
                }
            }
        end

        def create
            schedule = @master.master_schedules.create!(schedule_params)
            render json: schedule, status: :created
        end

        def destroy
            @schedule.destroy!
            head :no_content
        end

        private

        def set_master
            @master = Master.find(params[:master_id])
        end

        def set_schedule
            @schedule = @master.master_schedules.find(params[:id])
        end

        def schedule_params
            params.permit(:weekday, :start_time, :end_time)
        end
    end
end
