class CompleteNoteService
  class InvalidStatus < StandardError; end

  def initialize(note)
    @note = note
  end

  def call
    raise InvalidStatus, 'Note is not pending' unless @note.status == 'pending'

    @note.update!(status: 'completed')
  end
end
