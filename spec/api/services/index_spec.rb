require 'rails_helper'

RSpec.describe "services#index", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/services", params: params
  end

  describe 'basic fetch' do
    let!(:service1) { create(:service) }
    let!(:service2) { create(:service) }

    it 'works' do
      expect(ServiceResource).to receive(:all).and_call_original
      make_request
      expect(response.status).to eq(200), response.body
      expect(d.map(&:jsonapi_type).uniq).to match_array(['services'])
      expect(d.map(&:id)).to match_array([service1.id, service2.id])
    end
  end
end
