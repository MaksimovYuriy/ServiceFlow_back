require 'rails_helper'

RSpec.describe "notes#update", type: :request do
  subject(:make_request) do
    jsonapi_put "/api/notes/#{note.id}", payload
  end

  describe 'basic update' do
    let!(:note) { create(:note) }

    let(:payload) do
      {
        data: {
          id: note.id.to_s,
          type: 'notes',
          attributes: {
            # ... your attrs here
          }
        }
      }
    end

    # Replace 'xit' with 'it' after adding attributes
    xit 'updates the resource' do
      expect(NoteResource).to receive(:find).and_call_original
      expect {
        make_request
        expect(response.status).to eq(200), response.body
      }.to change { note.reload.attributes }
    end
  end
end
