module Analytics
  class ServicesService
    def self.call(period)
      completed_notes = Note.completed.where(start_at: period)
      total_revenue = completed_notes.sum(:total_price)

      services = Service.where(active: true)

      data = services.map do |service|
        service_notes = completed_notes.where(service_id: service.id)
        revenue = service_notes.sum(:total_price)

        {
          id: service.id,
          title: service.title,
          notes_count: service_notes.count,
          revenue: revenue.round(2),
          revenue_share: total_revenue.zero? ? 0 : (revenue * 100.0 / total_revenue).round(1)
        }
      end

      { services: data.sort_by { |s| -s[:notes_count] } }
    end
  end
end
