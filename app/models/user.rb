class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  # Include default devise modules. Others available are:

  has_many :user_roles
  has_many :roles, through: :user_roles
  
  has_one :doctor, dependent: :destroy
  has_one :hospital, dependent: :destroy
  has_many :appointments_as_patient, class_name: 'Appointment', foreign_key: 'patient_id'
  has_many :appointments_as_doctor, class_name: 'Appointment', foreign_key: 'doctor_id'
  
  validates :first_name, :last_name, presence: true
  
  def full_name
    "#{first_name} #{last_name}"
  end

  def patient?
    roles.exists?(name: 'patient')
  end
  
  def doctor?
    roles.exists?(name: 'doctor')
  end
  
  def hospital_admin?
    roles.exists?(name: 'hospital_admin')
  end
  
  def admin?
    roles.exists?(name: 'admin')
  end
end
