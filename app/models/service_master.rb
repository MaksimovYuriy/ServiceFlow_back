class ServiceMaster < ApplicationRecord
  belongs_to :service
  belongs_to :master

  validates :service_id, uniqueness: { scope: :master_id }
end
