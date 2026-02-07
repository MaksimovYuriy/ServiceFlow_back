class NotesController < ApplicationController
  skip_before_action :authenticate!, only: [:create]

  def create
    debugger
    client = Client.find_or_create_by!(phone: client_params[:phone])
    
    note = NoteResource.build(note_params(client))
    if note.save
      render jsonapi: note, status: 201
    else
      render jsonapi_errors: note
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
