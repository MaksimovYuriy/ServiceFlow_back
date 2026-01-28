class ServiceMasterResource < ApplicationResource
    attribute :service_id, :integer
    attribute :master_id, :integer

    attribute :master_name, :string do
        "#{@object.master.first_name} #{@object.master.last_name}"
    end

    belongs_to :service
    belongs_to :master

    filter :service_id, :integer do
        eq do |scope, value|
            scope.where(service_id: value)
        end
    end
end