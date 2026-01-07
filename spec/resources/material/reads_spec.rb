require 'rails_helper'

RSpec.describe MaterialResource, type: :resource do
  describe 'serialization' do
    let!(:material) { create(:material) }

    it 'works' do
      render
      data = jsonapi_data[0]
      expect(data.id).to eq(material.id)
      expect(data.jsonapi_type).to eq('materials')
    end
  end

  describe 'filtering' do
    let!(:material1) { create(:material) }
    let!(:material2) { create(:material) }

    context 'by id' do
      before do
        params[:filter] = { id: { eq: material2.id } }
      end

      it 'works' do
        render
        expect(d.map(&:id)).to eq([material2.id])
      end
    end
  end

  describe 'sorting' do
    describe 'by id' do
      let!(:material1) { create(:material) }
      let!(:material2) { create(:material) }

      context 'when ascending' do
        before do
          params[:sort] = 'id'
        end

        it 'works' do
          render
          expect(d.map(&:id)).to eq([
            material1.id,
            material2.id
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
            material2.id,
            material1.id
          ])
        end
      end
    end
  end

  describe 'sideloading' do
    # ... your tests ...
  end
end
