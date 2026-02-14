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

    sort :start_at

    attribute :client_name, :string do
        "#{@object.client.full_name}"
    end

    attribute :master_name, :string do
        "#{@object.master.first_name} #{@object.master.last_name}"
    end

    attribute :service_title, :string do
        "#{@object.service.title}"
    end

    filter :date, :string do
        eq do |scope, value|
            date = Date.parse(value.first)

            scope.where(start_at: date.beginning_of_day..date.end_of_day)
        end
    end
end
