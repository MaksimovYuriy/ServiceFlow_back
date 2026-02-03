require 'rails_helper'

RSpec.describe "clients#create", type: :request do
  subject(:make_request) do
    jsonapi_post "/api/clients", payload
  end

  describe 'basic create' do
    let(:params) do
      {
        # ... your attrs here
      }
    end
    let(:payload) do
      {
        data: {
          type: 'clients',
          attributes: params
        }
      }
    end

    it 'works' do
      expect(ClientResource).to receive(:build).and_call_original
      expect {
        make_request
        expect(response.status).to eq(201), response.body
      }.to change { Client.count }.by(1)
    end
  end
end
