class ServiceResource < ApplicationResource
  attribute :title, :string
  attribute :description, :string
  attribute :duration, :string
  attribute :price, :integer
  attribute :active, :boolean

  has_many :service_materials
end
