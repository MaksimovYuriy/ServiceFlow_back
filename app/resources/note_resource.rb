class NoteResource < ApplicationResource
    attribute :status, :string
    attribute :total_price, :float
    attribute :service_id, :integer
    attribute :client_id, :integer
    attribute :master_id, :integer
    attribute :start_at, :datetime
    attribute :end_at, :datetime

    belongs_to :client
    belongs_to :master
    belongs_to :service
end
