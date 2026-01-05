require 'rails_helper'

RSpec.describe MasterResource, type: :resource do
  describe 'creating' do
    let(:payload) do
      {
        data: {
          type: 'masters',
          attributes: { }
        }
      }
    end

    let(:instance) do
      MasterResource.build(payload)
    end

    it 'works' do
      expect {
        expect(instance.save).to eq(true), instance.errors.full_messages.to_sentence
      }.to change { Master.count }.by(1)
    end
  end

  describe 'updating' do
    let!(:master) { create(:master) }

    let(:payload) do
      {
        data: {
          id: master.id.to_s,
          type: 'masters',
          attributes: { } # Todo!
        }
      }
    end

    let(:instance) do
      MasterResource.find(payload)
    end

    xit 'works (add some attributes and enable this spec)' do
      expect {
        expect(instance.update_attributes).to eq(true)
      }.to change { master.reload.updated_at }
      # .and change { master.foo }.to('bar') <- example
    end
  end

  describe 'destroying' do
    let!(:master) { create(:master) }

    let(:instance) do
      MasterResource.find(id: master.id)
    end

    it 'works' do
      expect {
        expect(instance.destroy).to eq(true)
      }.to change { Master.count }.by(-1)
    end
  end
end
