class Service < ApplicationRecord
  has_many :service_materials, dependent: :destroy
  has_many :service_masters, dependent: :destroy
  has_many :materials, through: :service_materials
  has_many :masters, through: :service_masters
  has_many :notes, dependent: :restrict_with_error

  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :duration, presence: true
end
