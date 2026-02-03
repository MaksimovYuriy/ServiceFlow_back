require 'rails_helper'

RSpec.describe "clients#destroy", type: :request do
  subject(:make_request) do
    jsonapi_delete "/api/clients/#{client.id}"
  end

  describe 'basic destroy' do
    let!(:client) { create(:client) }

    it 'updates the resource' do
      expect(ClientResource).to receive(:find).and_call_original
      expect {
        make_request
        expect(response.status).to eq(200), response.body
      }.to change { Client.count }.by(-1)
      expect { client.reload }
        .to raise_error(ActiveRecord::RecordNotFound)
      expect(json).to eq('meta' => {})
    end
  end
end
