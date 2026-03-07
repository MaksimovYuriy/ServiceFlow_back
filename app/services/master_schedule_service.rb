class MasterScheduleService
  def initialize(master)
    @master = master
  end

  def call
    @master.master_schedules.order(:weekday, :start_time).map do |s|
      {
        id: s.id,
        weekday: s.weekday,
        start_time: s.start_time_hh_mm,
        end_time: s.end_time_hh_mm
      }
    end
  end
end
