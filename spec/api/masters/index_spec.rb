require 'rails_helper'

RSpec.describe "masters#index", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/masters", params: params
  end

  describe 'basic fetch' do
    let!(:master1) { create(:master) }
    let!(:master2) { create(:master) }

    it 'works' do
      expect(MasterResource).to receive(:all).and_call_original
      make_request
      expect(response.status).to eq(200), response.body
      expect(d.map(&:jsonapi_type).uniq).to match_array(['masters'])
      expect(d.map(&:id)).to match_array([master1.id, master2.id])
    end
  end
end
