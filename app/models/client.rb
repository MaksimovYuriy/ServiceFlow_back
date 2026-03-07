class Client < ApplicationRecord
  has_many :notes, dependent: :restrict_with_error

  validates :full_name, presence: true
  validates :phone, presence: true, uniqueness: true
end
