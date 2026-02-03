require 'rails_helper'

RSpec.describe "clients#index", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/clients", params: params
  end

  describe 'basic fetch' do
    let!(:client1) { create(:client) }
    let!(:client2) { create(:client) }

    it 'works' do
      expect(ClientResource).to receive(:all).and_call_original
      make_request
      expect(response.status).to eq(200), response.body
      expect(d.map(&:jsonapi_type).uniq).to match_array(['clients'])
      expect(d.map(&:id)).to match_array([client1.id, client2.id])
    end
  end
end
