require 'rails_helper'

RSpec.describe "materials#show", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/materials/#{material.id}", params: params
  end

  describe 'basic fetch' do
    let!(:material) { create(:material) }

    it 'works' do
      expect(MaterialResource).to receive(:find).and_call_original
      make_request
      expect(response.status).to eq(200)
      expect(d.jsonapi_type).to eq('materials')
      expect(d.id).to eq(material.id)
    end
  end
end
