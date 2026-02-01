class MasterResource < ApplicationResource
  attribute :first_name, :string
  attribute :middle_name, :string
  attribute :last_name, :string
  attribute :salary, :integer, readable: false
  attribute :phone, :string
  attribute :active, :boolean

  attribute :full_name, :string do
    "#{@object.first_name} #{@object.last_name}"
  end

  filter :service_id, :integer do
    eq do |scope, value|
      scope.joins(:service_masters)
           .where(service_masters: { service_id: value })
           .distinct
    end
  end
end
