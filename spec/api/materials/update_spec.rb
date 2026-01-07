require 'rails_helper'

RSpec.describe "materials#update", type: :request do
  subject(:make_request) do
    jsonapi_put "/api/materials/#{material.id}", payload
  end

  describe 'basic update' do
    let!(:material) { create(:material) }

    let(:payload) do
      {
        data: {
          id: material.id.to_s,
          type: 'materials',
          attributes: {
            # ... your attrs here
          }
        }
      }
    end

    # Replace 'xit' with 'it' after adding attributes
    xit 'updates the resource' do
      expect(MaterialResource).to receive(:find).and_call_original
      expect {
        make_request
        expect(response.status).to eq(200), response.body
      }.to change { material.reload.attributes }
    end
  end
end
