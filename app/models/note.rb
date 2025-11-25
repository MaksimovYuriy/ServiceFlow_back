class Note < ApplicationRecord
  belongs_to :service
  belongs_to :client
  belongs_to :master
end
