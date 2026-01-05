require 'rails_helper'

RSpec.describe MasterResource, type: :resource do
  describe 'serialization' do
    let!(:master) { create(:master) }

    it 'works' do
      render
      data = jsonapi_data[0]
      expect(data.id).to eq(master.id)
      expect(data.jsonapi_type).to eq('masters')
    end
  end

  describe 'filtering' do
    let!(:master1) { create(:master) }
    let!(:master2) { create(:master) }

    context 'by id' do
      before do
        params[:filter] = { id: { eq: master2.id } }
      end

      it 'works' do
        render
        expect(d.map(&:id)).to eq([master2.id])
      end
    end
  end

  describe 'sorting' do
    describe 'by id' do
      let!(:master1) { create(:master) }
      let!(:master2) { create(:master) }

      context 'when ascending' do
        before do
          params[:sort] = 'id'
        end

        it 'works' do
          render
          expect(d.map(&:id)).to eq([
            master1.id,
            master2.id
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
            master2.id,
            master1.id
          ])
        end
      end
    end
  end

  describe 'sideloading' do
    # ... your tests ...
  end
end
