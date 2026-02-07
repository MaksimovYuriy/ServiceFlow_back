class MaterialOperation < ApplicationRecord
  belongs_to :material
  belongs_to :note, optional: true

  enum status: {
    pending: 0,
    applied: 1,
    cancelled: 2
  }

  enum operation_type: {
    in: 0,
    out: 1
  }

  enum source: {
    manual: 0,
    booking: 1
  }

  validates :amount, numericality: { greater_than: 0 }
end
