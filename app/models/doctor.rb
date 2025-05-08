class Doctor < ApplicationRecord
  belongs_to :user
  has_many :availabilities, dependent: :destroy
  has_many :appointments, foreign_key: 'doctor_id', dependent: :destroy
  has_many :hospitals, through: :appointments
  
  validates :specialty, :license_number, presence: true
  validates :years_of_experience, numericality: { greater_than_or_equal_to: 0 }
  
  geocoded_by :address
  after_validation :geocode, if: ->(obj){ obj.address.present? && obj.address_changed? }
  
  def full_address
    "#{user.address}, #{user.city}, #{user.state}, #{user.country}"
  end

  scope :upcoming, -> { where('appointment_date >= ?', Time.current).order(appointment_date: :asc) }

end
