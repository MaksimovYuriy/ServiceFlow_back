require 'rails_helper'

RSpec.describe "materials#destroy", type: :request do
  subject(:make_request) do
    jsonapi_delete "/api/materials/#{material.id}"
  end

  describe 'basic destroy' do
    let!(:material) { create(:material) }

    it 'updates the resource' do
      expect(MaterialResource).to receive(:find).and_call_original
      expect {
        make_request
        expect(response.status).to eq(200), response.body
      }.to change { Material.count }.by(-1)
      expect { material.reload }
        .to raise_error(ActiveRecord::RecordNotFound)
      expect(json).to eq('meta' => {})
    end
  end
end
