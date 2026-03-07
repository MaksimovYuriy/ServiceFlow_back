class Material < ApplicationRecord
  has_many :service_materials, dependent: :destroy
  has_many :material_operations, dependent: :destroy
  has_many :services, through: :service_materials

  validates :title, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :minimal_quantity, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
