module Analytics
  class SummaryService
    def self.call(period)
      notes = Note.where(start_at: period)
      completed = notes.completed

      {
        period_from: period.first.to_date.to_s,
        period_to: period.last.to_date.to_s,
        total_notes: notes.count,
        completed: completed.count,
        canceled: notes.canceled.count,
        pending: notes.pending.count,
        total_revenue: completed.sum(:total_price).round(2),
        average_check: completed.average(:total_price)&.round(2) || 0,
        cancellation_rate: notes.count.zero? ? 0 : (notes.canceled.count * 100.0 / notes.count).round(1),
        total_clients: notes.distinct.count(:client_id),
        total_masters: notes.distinct.count(:master_id),
        total_services: notes.distinct.count(:service_id)
      }
    end
  end
end
