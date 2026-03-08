module Analytics
  class ClientsService
    def self.call(period)
      period_notes = Note.where(start_at: period)

      unique_clients = period_notes.distinct.count(:client_id)
      new_clients = Client.where(created_at: period).count

      repeat_client_ids = period_notes.completed
                                      .group(:client_id)
                                      .having("COUNT(*) > 1")
                                      .count
                                      .size

      top_clients = Client
        .joins(:notes)
        .merge(Note.completed.where(start_at: period))
        .group("clients.id", "clients.full_name", "clients.phone")
        .order("COUNT(notes.id) DESC")
        .limit(10)
        .pluck("clients.id", "clients.full_name", "clients.phone", Arel.sql("COUNT(notes.id)"), Arel.sql("SUM(notes.total_price)"))
        .map do |id, name, phone, visits, spent|
          {
            id: id,
            name: name,
            phone: phone,
            visits: visits,
            total_spent: spent.to_f.round(2)
          }
        end

      {
        unique_clients: unique_clients,
        new_clients: new_clients,
        repeat_clients: repeat_client_ids,
        top_clients: top_clients
      }
    end
  end
end
