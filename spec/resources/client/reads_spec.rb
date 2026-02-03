require 'rails_helper'

RSpec.describe ClientResource, type: :resource do
  describe 'serialization' do
    let!(:client) { create(:client) }

    it 'works' do
      render
      data = jsonapi_data[0]
      expect(data.id).to eq(client.id)
      expect(data.jsonapi_type).to eq('clients')
    end
  end

  describe 'filtering' do
    let!(:client1) { create(:client) }
    let!(:client2) { create(:client) }

    context 'by id' do
      before do
        params[:filter] = { id: { eq: client2.id } }
      end

      it 'works' do
        render
        expect(d.map(&:id)).to eq([client2.id])
      end
    end
  end

  describe 'sorting' do
    describe 'by id' do
      let!(:client1) { create(:client) }
      let!(:client2) { create(:client) }

      context 'when ascending' do
        before do
          params[:sort] = 'id'
        end

        it 'works' do
          render
          expect(d.map(&:id)).to eq([
            client1.id,
            client2.id
          ])
        end
      end

      context 'when descending' do
        before do
          params[:sort] = '-id'
        end

        it 'works' do
          render
          expect(d.map(&:id)).to eq([
            client2.id,
            client1.id
          ])
        end
      end
    end
  end

  describe 'sideloading' do
    # ... your tests ...
  end
end
