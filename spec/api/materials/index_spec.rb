require 'rails_helper'

RSpec.describe "materials#index", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/materials", params: params
  end

  describe 'basic fetch' do
    let!(:material1) { create(:material) }
    let!(:material2) { create(:material) }

    it 'works' do
      expect(MaterialResource).to receive(:all).and_call_original
      make_request
      expect(response.status).to eq(200), response.body
      expect(d.map(&:jsonapi_type).uniq).to match_array(['materials'])
      expect(d.map(&:id)).to match_array([material1.id, material2.id])
    end
  end
end
