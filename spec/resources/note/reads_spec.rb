require 'rails_helper'

RSpec.describe NoteResource, type: :resource do
  describe 'serialization' do
    let!(:note) { create(:note) }

    it 'works' do
      render
      data = jsonapi_data[0]
      expect(data.id).to eq(note.id)
      expect(data.jsonapi_type).to eq('notes')
    end
  end

  describe 'filtering' do
    let!(:note1) { create(:note) }
    let!(:note2) { create(:note) }

    context 'by id' do
      before do
        params[:filter] = { id: { eq: note2.id } }
      end

      it 'works' do
        render
        expect(d.map(&:id)).to eq([note2.id])
      end
    end
  end

  describe 'sorting' do
    describe 'by id' do
      let!(:note1) { create(:note) }
      let!(:note2) { create(:note) }

      context 'when ascending' do
        before do
          params[:sort] = 'id'
        end

        it 'works' do
          render
          expect(d.map(&:id)).to eq([
            note1.id,
            note2.id
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
            note2.id,
            note1.id
          ])
        end
      end
    end
  end

  describe 'sideloading' do
    # ... your tests ...
  end
end
