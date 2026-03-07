class CancelNoteService
  class InvalidStatus < StandardError; end

  def initialize(note)
    @note = note
  end

  def call
    raise InvalidStatus, 'Note is not pending' unless @note.status == 'pending'

    ActiveRecord::Base.transaction do
      @note.update!(status: 'canceled')
      ReturnMaterialsService.new(@note).call
    end
  end
end
