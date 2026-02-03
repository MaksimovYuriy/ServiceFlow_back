require 'rails_helper'

RSpec.describe NoteResource, type: :resource do
  describe 'creating' do
    let(:payload) do
      {
        data: {
          type: 'notes',
          attributes: { }
        }
      }
    end

    let(:instance) do
      NoteResource.build(payload)
    end

    it 'works' do
      expect {
        expect(instance.save).to eq(true), instance.errors.full_messages.to_sentence
      }.to change { Note.count }.by(1)
    end
  end

  describe 'updating' do
    let!(:note) { create(:note) }

    let(:payload) do
      {
        data: {
          id: note.id.to_s,
          type: 'notes',
          attributes: { } # Todo!
        }
      }
    end

    let(:instance) do
      NoteResource.find(payload)
    end

    xit 'works (add some attributes and enable this spec)' do
      expect {
        expect(instance.update_attributes).to eq(true)
      }.to change { note.reload.updated_at }
      # .and change { note.foo }.to('bar') <- example
    end
  end

  describe 'destroying' do
    let!(:note) { create(:note) }

    let(:instance) do
      NoteResource.find(id: note.id)
    end

    it 'works' do
      expect {
        expect(instance.destroy).to eq(true)
      }.to change { Note.count }.by(-1)
    end
  end
end
