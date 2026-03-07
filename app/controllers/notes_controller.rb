class NotesController < ApplicationController
  skip_before_action :authenticate!, only: [:create]

  def index
    unless index_params[:date].present?
      return render json: { error: 'filter[date] is required' }, status: :bad_request
    end

    notes = NoteResource.all(params)
    respond_with(notes)
  end

  def create
    note = CreateNoteService.new(
      client_params: client_params,
      note_params: note_params
    ).call

    render jsonapi: note, status: 201
  rescue CreateNoteService::ClientBlocked => e
    render json: { error: e.message }, status: :forbidden
  rescue Materials::OperationsProvider::NotEnoughMaterial
    render json: { error: 'Произошла непредвиденная ошибка, услуга сейчас недоступна для записи' }, status: :unprocessable_entity
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def complete
    note = Note.find(params[:id])
    CompleteNoteService.new(note).call
    render json: { success: true }
  rescue CompleteNoteService::InvalidStatus => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def cancel
    note = Note.find(params[:id])
    CancelNoteService.new(note).call
    render json: { success: true }
  rescue CancelNoteService::InvalidStatus => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def index_params
    params.require(:filter).permit(:date)
  end

  def client_params
    params.require(:data).require(:attributes).require(:client)
  end

  def note_params
    attrs = params.require(:data)
                  .require(:attributes)
                  .permit(:master_id, :service_id, :start_at, :end_at)

    { type: params[:data][:type], attributes: attrs.except(:client) }
  end
end
