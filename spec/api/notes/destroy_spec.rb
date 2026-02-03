require 'rails_helper'

RSpec.describe "notes#destroy", type: :request do
  subject(:make_request) do
    jsonapi_delete "/api/notes/#{note.id}"
  end

  describe 'basic destroy' do
    let!(:note) { create(:note) }

    it 'updates the resource' do
      expect(NoteResource).to receive(:find).and_call_original
      expect {
        make_request
        expect(response.status).to eq(200), response.body
      }.to change { Note.count }.by(-1)
      expect { note.reload }
        .to raise_error(ActiveRecord::RecordNotFound)
      expect(json).to eq('meta' => {})
    end
  end
end
