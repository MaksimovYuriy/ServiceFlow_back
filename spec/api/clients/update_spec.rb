require 'rails_helper'

RSpec.describe "clients#update", type: :request do
  subject(:make_request) do
    jsonapi_put "/api/clients/#{client.id}", payload
  end

  describe 'basic update' do
    let!(:client) { create(:client) }

    let(:payload) do
      {
        data: {
          id: client.id.to_s,
          type: 'clients',
          attributes: {
            # ... your attrs here
          }
        }
      }
    end

    # Replace 'xit' with 'it' after adding attributes
    xit 'updates the resource' do
      expect(ClientResource).to receive(:find).and_call_original
      expect {
        make_request
        expect(response.status).to eq(200), response.body
      }.to change { client.reload.attributes }
    end
  end
end
