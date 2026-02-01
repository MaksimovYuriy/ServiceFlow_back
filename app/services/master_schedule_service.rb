# app/services/master_schedule_service.rb
class MasterScheduleService
  def initialize(master)
    @master = master
  end

  def available_dates(days_count = 30)
    today = Date.current
    (0...days_count).map { |i| today + i }
                   .select { |date| working_day?(date) }
  end

  def available_slots(date, step_minutes = 60)
    schedules = @master.master_schedules.where(weekday: date.wday)

    bookings = @master.notes.where(start_at: date.beginning_of_day..date.end_of_day)

    slots = []

    schedules.each do |schedule|
        start_time = Time.zone.parse("#{date} #{schedule.start_time}")
        end_time = Time.zone.parse("#{date} #{schedule.end_time}")

        current_start = start_time

        while (current_start + step_minutes.minutes) <= end_time
            current_end = current_start + step_minutes.minutes

            unless bookings.any? { |b| (current_start...current_end).overlaps?(b.start_at...b.end_at) }
                slots << { start_time: current_start.strftime("%H:%M"), end_time: current_end.strftime("%H:%M") }
            end

            current_start = current_end
        end
    end

    slots
  end


  private

  def working_day?(date)
    @master.master_schedules.exists?(weekday: date.wday)
  end

  def time_overlap?(booking_start, booking_end, date, schedule_start_time, schedule_end_time)
    schedule_start = Time.zone.parse("#{date} #{schedule_start_time}")
    schedule_end = Time.zone.parse("#{date} #{schedule_end_time}")
    (schedule_start...schedule_end).overlaps?(booking_start...booking_end)
  end
end
