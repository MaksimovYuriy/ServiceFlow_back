module Analytics
  class MastersService
    def self.call(period)
      masters = Master.where(active: true).includes(:master_schedules)

      data = masters.map do |master|
        period_notes = master.notes.where(start_at: period)
        completed = period_notes.completed
        total = period_notes.count

        schedule_hours = master.master_schedules.sum do |s|
          (s.end_time - s.start_time) / 3600.0
        end

        booked_hours = completed.sum { |n| (n.end_at - n.start_at) / 3600.0 }

        {
          id: master.id,
          name: [master.last_name, master.first_name, master.middle_name].compact.join(" "),
          completed_notes: completed.count,
          revenue: completed.sum(:total_price).round(2),
          cancellation_rate: total.zero? ? 0 : (period_notes.canceled.count * 100.0 / total).round(1),
          weekly_schedule_hours: schedule_hours.round(1),
          total_booked_hours: booked_hours.round(1)
        }
      end

      { masters: data.sort_by { |m| -m[:revenue] } }
    end
  end
end
