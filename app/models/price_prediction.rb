class PricePrediction < ApplicationRecord
  enum status: {
    queued:    0,
    running:   1,
    completed: 2,
    failed:    3
  }

  scope :recent,    -> { order(created_at: :desc) }
  scope :active,    -> { where(status: %i[queued running]) }
  scope :finalized, -> { where(status: %i[completed failed]) }
end
