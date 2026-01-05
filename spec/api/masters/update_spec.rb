require 'rails_helper'

RSpec.describe "masters#update", type: :request do
  subject(:make_request) do
    jsonapi_put "/api/masters/#{master.id}", payload
  end

  describe 'basic update' do
    let!(:master) { create(:master) }

    let(:payload) do
      {
        data: {
          id: master.id.to_s,
          type: 'masters',
          attributes: {
            # ... your attrs here
          }
        }
      }
    end

    # Replace 'xit' with 'it' after adding attributes
    xit 'updates the resource' do
      expect(MasterResource).to receive(:find).and_call_original
      expect {
        make_request
        expect(response.status).to eq(200), response.body
      }.to change { master.reload.attributes }
    end
  end
end
