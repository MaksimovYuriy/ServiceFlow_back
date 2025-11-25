class Service < ApplicationRecord
    has_many :service_materials
    has_many :service_masters
end
