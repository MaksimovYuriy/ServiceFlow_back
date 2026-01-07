require 'rails_helper'

RSpec.describe "materials#create", type: :request do
  subject(:make_request) do
    jsonapi_post "/api/materials", payload
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
          type: 'materials',
          attributes: params
        }
      }
    end

    it 'works' do
      expect(MaterialResource).to receive(:build).and_call_original
      expect {
        make_request
        expect(response.status).to eq(201), response.body
      }.to change { Material.count }.by(1)
    end
  end
end
