class NotesController < ApplicationController
  skip_before_action :authenticate!, only: [:create]

  def create
    client = Client.find_or_create_by!(phone: client_params[:phone])
    client.update(full_name: client_params[:full_name], telegram: client_params[:telegram])
    
    note = NoteResource.build(note_params(client))
    
    ActiveRecord::Base.transaction do
      if note.save
        begin
          ConsumeMaterialsService.new(note).call
          DiscontService.new(note).call
          render jsonapi: note, status: 201
        rescue Materials::OperationsProvider::NotEnoughMaterial => e
          note.data.destroy
          render json: { error: "Недостаточно материалов: #{e.message}" }, status: :unprocessable_entity
        end
      else
        render jsonapi_errors: note
      end
    end
  end

  private

  def client_params
    params.require(:data).require(:attributes).require(:client)
  end

  def note_params(client)
    attrs = params.require(:data)
                  .require(:attributes)
                  .permit(:master_id, :service_id, :start_at, :end_at)

    filtered_attrs = attrs.except(:client).merge(client_id: client.id)

    filtered_params = {
      data: {
        type: params[:data][:type],
        attributes: filtered_attrs
      }
    }
  end
end
