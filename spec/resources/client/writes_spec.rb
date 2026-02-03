require 'rails_helper'

RSpec.describe ClientResource, type: :resource do
  describe 'creating' do
    let(:payload) do
      {
        data: {
          type: 'clients',
          attributes: { }
        }
      }
    end

    let(:instance) do
      ClientResource.build(payload)
    end

    it 'works' do
      expect {
        expect(instance.save).to eq(true), instance.errors.full_messages.to_sentence
      }.to change { Client.count }.by(1)
    end
  end

  describe 'updating' do
    let!(:client) { create(:client) }

    let(:payload) do
      {
        data: {
          id: client.id.to_s,
          type: 'clients',
          attributes: { } # Todo!
        }
      }
    end

    let(:instance) do
      ClientResource.find(payload)
    end

    xit 'works (add some attributes and enable this spec)' do
      expect {
        expect(instance.update_attributes).to eq(true)
      }.to change { client.reload.updated_at }
      # .and change { client.foo }.to('bar') <- example
    end
  end

  describe 'destroying' do
    let!(:client) { create(:client) }

    let(:instance) do
      ClientResource.find(id: client.id)
    end

    it 'works' do
      expect {
        expect(instance.destroy).to eq(true)
      }.to change { Client.count }.by(-1)
    end
  end
end
