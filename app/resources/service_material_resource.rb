class ServiceMaterialResource < ApplicationResource
    attribute :required_quantity, :integer
    attribute :service_id, :integer
    attribute :material_id, :integer

    attribute :material_title, :string do
        @object.material.title
    end

    belongs_to :service
    belongs_to :material

    filter :service_id, :integer do
        eq do |scope, value|
            scope.where(service_id: value)
        end
    end
end