require 'rails_helper'

RSpec.describe MaterialResource, type: :resource do
  describe 'creating' do
    let(:payload) do
      {
        data: {
          type: 'materials',
          attributes: { }
        }
      }
    end

    let(:instance) do
      MaterialResource.build(payload)
    end

    it 'works' do
      expect {
        expect(instance.save).to eq(true), instance.errors.full_messages.to_sentence
      }.to change { Material.count }.by(1)
    end
  end

  describe 'updating' do
    let!(:material) { create(:material) }

    let(:payload) do
      {
        data: {
          id: material.id.to_s,
          type: 'materials',
          attributes: { } # Todo!
        }
      }
    end

    let(:instance) do
      MaterialResource.find(payload)
    end

    xit 'works (add some attributes and enable this spec)' do
      expect {
        expect(instance.update_attributes).to eq(true)
      }.to change { material.reload.updated_at }
      # .and change { material.foo }.to('bar') <- example
    end
  end

  describe 'destroying' do
    let!(:material) { create(:material) }

    let(:instance) do
      MaterialResource.find(id: material.id)
    end

    it 'works' do
      expect {
        expect(instance.destroy).to eq(true)
      }.to change { Material.count }.by(-1)
    end
  end
end
