class ClientReliabilityService
  PERIOD = 3.months
  CANCELLATION_THRESHOLD = 10

  def initialize(client)
    @client = client
  end

  def reliable?
    cancellations_count < CANCELLATION_THRESHOLD
  end

  def cancellations_count
    Note.where(client_id: @client.id, status: :canceled)
        .where('start_at >= ?', PERIOD.ago)
        .count
  end
end
