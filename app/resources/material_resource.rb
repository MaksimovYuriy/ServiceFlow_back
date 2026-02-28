class MaterialResource < ApplicationResource
  attribute :title, :string
  attribute :quantity, :integer
  attribute :minimal_quantity, :integer
  attribute :price, :float

  has_many :service_materials
end
