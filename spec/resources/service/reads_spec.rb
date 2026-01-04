require 'rails_helper'

RSpec.describe ServiceResource, type: :resource do
  describe 'serialization' do
    let!(:service) { create(:service) }

    it 'works' do
      render
      data = jsonapi_data[0]
      expect(data.id).to eq(service.id)
      expect(data.jsonapi_type).to eq('services')
    end
  end

  describe 'filtering' do
    let!(:service1) { create(:service) }
    let!(:service2) { create(:service) }

    context 'by id' do
      before do
        params[:filter] = { id: { eq: service2.id } }
      end

      it 'works' do
        render
        expect(d.map(&:id)).to eq([service2.id])
      end
    end
  end

  describe 'sorting' do
    describe 'by id' do
      let!(:service1) { create(:service) }
      let!(:service2) { create(:service) }

      context 'when ascending' do
        before do
          params[:sort] = 'id'
        end

        it 'works' do
          render
          expect(d.map(&:id)).to eq([
            service1.id,
            service2.id
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
            service2.id,
            service1.id
          ])
        end
      end
    end
  end

  describe 'sideloading' do
    # ... your tests ...
  end
end
