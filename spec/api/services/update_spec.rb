require 'rails_helper'

RSpec.describe "services#update", type: :request do
  subject(:make_request) do
    jsonapi_put "/api/services/#{service.id}", payload
  end

  describe 'basic update' do
    let!(:service) { create(:service) }

    let(:payload) do
      {
        data: {
          id: service.id.to_s,
          type: 'services',
          attributes: {
            # ... your attrs here
          }
        }
      }
    end

    # Replace 'xit' with 'it' after adding attributes
    xit 'updates the resource' do
      expect(ServiceResource).to receive(:find).and_call_original
      expect {
        make_request
        expect(response.status).to eq(200), response.body
      }.to change { service.reload.attributes }
    end
  end
end
