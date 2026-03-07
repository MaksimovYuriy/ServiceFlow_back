class AvailableSlotsService
  STEP_MINUTES = 60

  def initialize(master, date:)
    @master = master
    @date = date
  end

  def call
    schedule = @master.master_schedules.find_by(weekday: @date.wday)
    return [] unless schedule

    bookings_ranges = @master.notes.actuals
                                   .where(start_at: @date.beginning_of_day..@date.end_of_day)
                                   .map { |b| (b.start_at.utc...b.end_at.utc) }

    start_time = Time.zone.parse("#{@date} #{schedule.start_time}").utc
    end_time = Time.zone.parse("#{@date} #{schedule.end_time}").utc

    slots = []
    current_start = start_time

    while (current_start + STEP_MINUTES.minutes) <= end_time
      current_end = current_start + STEP_MINUTES.minutes

      unless bookings_ranges.any? { |range| (current_start...current_end).overlaps?(range) }
        slots << { start_time: current_start.strftime("%H:%M"), end_time: current_end.strftime("%H:%M") }
      end

      current_start = current_end
    end

    slots
  end
end
