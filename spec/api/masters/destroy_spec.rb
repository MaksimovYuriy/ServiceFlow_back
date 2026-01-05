require 'rails_helper'

RSpec.describe "masters#destroy", type: :request do
  subject(:make_request) do
    jsonapi_delete "/api/masters/#{master.id}"
  end

  describe 'basic destroy' do
    let!(:master) { create(:master) }

    it 'updates the resource' do
      expect(MasterResource).to receive(:find).and_call_original
      expect {
        make_request
        expect(response.status).to eq(200), response.body
      }.to change { Master.count }.by(-1)
      expect { master.reload }
        .to raise_error(ActiveRecord::RecordNotFound)
      expect(json).to eq('meta' => {})
    end
  end
end
