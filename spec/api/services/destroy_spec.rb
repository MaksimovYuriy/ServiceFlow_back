require 'rails_helper'

RSpec.describe "services#destroy", type: :request do
  subject(:make_request) do
    jsonapi_delete "/api/services/#{service.id}"
  end

  describe 'basic destroy' do
    let!(:service) { create(:service) }

    it 'updates the resource' do
      expect(ServiceResource).to receive(:find).and_call_original
      expect {
        make_request
        expect(response.status).to eq(200), response.body
      }.to change { Service.count }.by(-1)
      expect { service.reload }
        .to raise_error(ActiveRecord::RecordNotFound)
      expect(json).to eq('meta' => {})
    end
  end
end
