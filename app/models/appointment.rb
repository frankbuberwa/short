class Appointment < ApplicationRecord
  belongs_to :patient, class_name: 'User'
  belongs_to :doctor
  belongs_to :hospital
  
  validates :appointment_date, presence: true

  attribute :status, :string, default: 'pending'
  validates :status, inclusion: { in: %w[pending confirmed cancelled completed] }

  scope :upcoming, -> { where('appointment_date >= ?', Time.current).order(appointment_date: :asc) }
  
  #enum status: { pending: 'pending', confirmed: 'confirmed', cancelled: 'cancelled', completed: 'completed' }
end
