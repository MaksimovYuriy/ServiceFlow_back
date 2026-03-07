class CreateNoteService
  class ClientBlocked < StandardError; end

  def initialize(client_params:, note_params:)
    @client_params = client_params
    @note_params = note_params
  end

  def call
    client = find_or_create_client
    validate_reliability!(client)
    resource_params = build_resource_params(client)
    note = NoteResource.build(resource_params)

    ActiveRecord::Base.transaction do
      raise ActiveRecord::RecordInvalid, note.data unless note.save

      ConsumeMaterialsService.new(note).call
      DiscontService.new(note).call
    end

    note
  end

  private

  def find_or_create_client
    client = Client.find_or_initialize_by(phone: @client_params[:phone])
    client.assign_attributes(full_name: @client_params[:full_name], telegram: @client_params[:telegram])
    client.save!
    client
  end

  def validate_reliability!(client)
    return if ClientReliabilityService.new(client).call

    raise ClientBlocked, 'Запись для данного клиента временно недоступна из-за частых отмен. Ограничение будет снято автоматически.'
  end

  def build_resource_params(client)
    attrs = @note_params[:attributes].merge(client_id: client.id)

    {
      data: {
        type: @note_params[:type],
        attributes: attrs
      }
    }
  end
end
