class ServiceMaterial < ApplicationRecord
  belongs_to :service
  belongs_to :material

  validates :required_quantity, presence: true, numericality: { greater_than: 0 }
end
