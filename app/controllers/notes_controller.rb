class NotesController < ApplicationController
  skip_before_action :authenticate!, only: [:create]

  def create
    note = NoteResource.build(params)

    if note.save
      render jsonapi: note, status: 201
    else
      render jsonapi_errors: note
    end
  end
end
