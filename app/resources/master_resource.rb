class MasterResource < ApplicationResource
  attribute :first_name, :string
  attribute :middle_name, :string
  attribute :last_name, :string
  attribute :salary, :integer
  attribute :phone, :string
  attribute :active, :boolean

  attribute :full_name, :string do
    "#{@object.first_name} #{@object.last_name}"
  end
end
