class AvailableDatesService
  def initialize(master, days_count: 30)
    @master = master
    @days_count = days_count
  end

  def call
    today = Date.current
    (0...@days_count).map { |i| today + i }
                     .select { |date| working_day?(date) }
  end

  private

  def working_day?(date)
    @master.master_schedules.exists?(weekday: date.wday)
  end
end
