class Master < ApplicationRecord
    has_many :service_masters
    has_many :notes
    has_many :master_schedules, dependent: :destroy
end
