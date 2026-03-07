class ClientReliabilityService
  PERIOD = 3.months
  CANCELLATION_THRESHOLD = 10

  def initialize(client)
    @client = client
  end

  def call
    cancellations_count < CANCELLATION_THRESHOLD
  end

  private

  def cancellations_count
    Note.where(client_id: @client.id, status: :canceled)
        .where('start_at >= ?', PERIOD.ago)
        .count
  end
end
