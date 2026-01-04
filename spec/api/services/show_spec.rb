require 'rails_helper'

RSpec.describe "services#show", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/services/#{service.id}", params: params
  end

  describe 'basic fetch' do
    let!(:service) { create(:service) }

    it 'works' do
      expect(ServiceResource).to receive(:find).and_call_original
      make_request
      expect(response.status).to eq(200)
      expect(d.jsonapi_type).to eq('services')
      expect(d.id).to eq(service.id)
    end
  end
end
