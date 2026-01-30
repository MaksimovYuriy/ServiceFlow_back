class MasterSchedule < ApplicationRecord
  belongs_to :master

  validates :weekday, inclusion: { in: 0..6 }
  validates :start_time, :end_time, presence: true
  validate :end_after_start

  def end_after_start
    return if start_time.blank? || end_time.blank?

    if end_time <= start_time
      errors.add(:end_time, 'must br after start_time')
    end
  end

  def no_overlap
    return if start_time.blank? || end_time.blank?

    overlap = MasterSchedule.where(master_id: master_id, weekday: weekday)
                            .where.not(id: id)
                            .where('start_time < ? AND end_time > ?', end_time, start_time)
                            .exists?
    
    errors.add(:base, 'Schedule overlaps existing interval') if overlap
  end

  def start_time_hh_mm
    start_time.strftime("%H:%M")
  end

  def end_time_hh_mm
    end_time.strftime("%H:%M")
  end
end
