module Analytics
  class RevenueService
    def self.call(period)
      notes = Note.where(start_at: period)

      start_date = period.first.to_date.beginning_of_month
      end_date = period.last.to_date.beginning_of_month
      months = []
      current = start_date
      while current <= end_date
        months << current
        current = current.next_month
      end

      monthly = months.map do |month|
        month_range = month.beginning_of_day..month.end_of_month.end_of_day
        month_notes = notes.where(start_at: month_range)

        {
          month: month.strftime("%Y-%m"),
          revenue: month_notes.completed.sum(:total_price).round(2),
          notes_count: month_notes.completed.count,
          canceled_count: month_notes.canceled.count
        }
      end

      { monthly: monthly }
    end
  end
end
