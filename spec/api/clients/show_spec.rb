require 'rails_helper'

RSpec.describe "clients#show", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/clients/#{client.id}", params: params
  end

  describe 'basic fetch' do
    let!(:client) { create(:client) }

    it 'works' do
      expect(ClientResource).to receive(:find).and_call_original
      make_request
      expect(response.status).to eq(200)
      expect(d.jsonapi_type).to eq('clients')
      expect(d.id).to eq(client.id)
    end
  end
end
