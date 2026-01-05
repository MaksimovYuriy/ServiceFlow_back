require 'rails_helper'

RSpec.describe "masters#show", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/masters/#{master.id}", params: params
  end

  describe 'basic fetch' do
    let!(:master) { create(:master) }

    it 'works' do
      expect(MasterResource).to receive(:find).and_call_original
      make_request
      expect(response.status).to eq(200)
      expect(d.jsonapi_type).to eq('masters')
      expect(d.id).to eq(master.id)
    end
  end
end
