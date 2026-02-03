require 'rails_helper'

RSpec.describe "notes#index", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/notes", params: params
  end

  describe 'basic fetch' do
    let!(:note1) { create(:note) }
    let!(:note2) { create(:note) }

    it 'works' do
      expect(NoteResource).to receive(:all).and_call_original
      make_request
      expect(response.status).to eq(200), response.body
      expect(d.map(&:jsonapi_type).uniq).to match_array(['notes'])
      expect(d.map(&:id)).to match_array([note1.id, note2.id])
    end
  end
end
