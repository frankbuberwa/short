class Hospital < ApplicationRecord
  belongs_to :user
  has_many :appointments, dependent: :destroy
  has_many :doctors, through: :appointments
  
  geocoded_by :full_address
  after_validation :geocode
  
  validates :name, :address, :phone, presence: true
  
  def full_address
    address
  end
end
