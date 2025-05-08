# app/models/availability.rb
class Availability < ApplicationRecord
  belongs_to :doctor

  validates :start_time, :end_time, presence: true
  validate :end_time_after_start_time
  validate :no_overlapping_availabilities

  scope :upcoming, -> { where("start_time >= ?", Time.current).order(start_time: :asc) }
  scope :past, -> { where("start_time < ?", Time.current).order(start_time: :desc) }

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end

  def no_overlapping_availabilities
    return if start_time.blank? || end_time.blank?

    overlapping = doctor.availabilities.where.not(id: id).where(
      "(start_time, end_time) OVERLAPS (?, ?)", start_time, end_time
    )
    
    if overlapping.exists?
      errors.add(:base, "This availability overlaps with another existing availability")
    end
  end
end