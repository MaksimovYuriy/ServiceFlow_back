class Note < ApplicationRecord
  belongs_to :service
  belongs_to :client
  belongs_to :master

  has_many :material_operations, dependent: :nullify

  validates :start_at, :end_at, presence: true
  validate :end_after_start
  validate :no_overlap

  enum status: {
    pending: 0,
    canceled: 1,
    completed: 2
  }

  scope :actuals, -> {
    where.not(status: 'canceled')
  }

  def end_after_start
    return if start_at.blank? || end_at.blank?
    errors.add(:end_at, 'must be after start_at') if end_at <= start_at
  end

  def no_overlap
    return if start_at.blank? || end_at.blank?
    overlap = Note.where(master_id: master_id)
                  .where.not(id: id)
                  .where('start_at < ? AND end_at > ?', end_at, start_at)
                  .exists?
    errors.add(:base, 'Time slot is already taken') if overlap
  end
end
