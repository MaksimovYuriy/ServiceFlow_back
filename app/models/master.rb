class Master < ApplicationRecord
  has_many :service_masters, dependent: :destroy
  has_many :services, through: :service_masters
  has_many :notes, dependent: :restrict_with_error
  has_many :master_schedules, dependent: :destroy

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, presence: true, uniqueness: true
end
