require 'rails_helper'

RSpec.describe ServiceResource, type: :resource do
  describe 'creating' do
    let(:payload) do
      {
        data: {
          type: 'services',
          attributes: { }
        }
      }
    end

    let(:instance) do
      ServiceResource.build(payload)
    end

    it 'works' do
      expect {
        expect(instance.save).to eq(true), instance.errors.full_messages.to_sentence
      }.to change { Service.count }.by(1)
    end
  end

  describe 'updating' do
    let!(:service) { create(:service) }

    let(:payload) do
      {
        data: {
          id: service.id.to_s,
          type: 'services',
          attributes: { } # Todo!
        }
      }
    end

    let(:instance) do
      ServiceResource.find(payload)
    end

    xit 'works (add some attributes and enable this spec)' do
      expect {
        expect(instance.update_attributes).to eq(true)
      }.to change { service.reload.updated_at }
      # .and change { service.foo }.to('bar') <- example
    end
  end

  describe 'destroying' do
    let!(:service) { create(:service) }

    let(:instance) do
      ServiceResource.find(id: service.id)
    end

    it 'works' do
      expect {
        expect(instance.destroy).to eq(true)
      }.to change { Service.count }.by(-1)
    end
  end
end
