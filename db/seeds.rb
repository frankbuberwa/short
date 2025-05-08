# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
# Create roles
roles = [
  { name: 'admin', description: 'System administrator with full access' },
  { name: 'patient', description: 'Regular user who can book appointments' },
  { name: 'doctor', description: 'Medical professional who can be booked' },
  { name: 'hospital_admin', description: 'Administrator for a hospital' }
]

roles.each do |role|
  Role.find_or_create_by!(role)
end

# Create admin user
admin_user = User.create!(
  first_name: 'Admin',
  last_name: 'User',
  email: 'anita@hotmail.com',
  password: 'password',
  password_confirmation: 'password',
  address: '123 Admin St',
  city: 'Adminville',
  state: 'CA',
  country: 'USA',
  postal_code: '90210'
)

admin_user.roles << Role.find_by(name: 'admin')

# Create some patients
10.times do |i|
  patient = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: "patient#{i}@hotmail.com",
    password: 'password',
    password_confirmation: 'password',
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    country: 'USA',
    postal_code: Faker::Address.zip_code,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude
  )
  
  patient.roles << Role.find_by(name: 'patient')
end

# Create some doctors
specialties = [
  'Cardiology', 'Dermatology', 'Endocrinology', 'Gastroenterology', 
  'Neurology', 'Oncology', 'Pediatrics', 'Psychiatry', 'Radiology', 'Urology'
]

10.times do |i|
  doctor_user = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: "doctor#{i}@hotmail.com",
    password: 'password',
    password_confirmation: 'password',
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    country: 'USA',
    postal_code: Faker::Address.zip_code,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude
  )
  
  doctor_user.roles << Role.find_by(name: 'doctor')
  
  Doctor.create!(
    user: doctor_user,
    specialty: specialties.sample,
    license_number: "MD#{rand(100000..999999)}",
    years_of_experience: rand(1..30)
  )
end

# Create some hospitals
5.times do |i|
  hospital_admin = User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: "hospital_admin#{i}@yahoo.com",
    password: 'password',
    password_confirmation: 'password',
    address: Faker::Address.street_address,
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    country: 'USA',
    postal_code: Faker::Address.zip_code
  )
  
  hospital_admin.roles << Role.find_by(name: 'hospital_admin')
  
  Hospital.create!(
    user: hospital_admin,
    name: "#{Faker::Name.first_name} #{['Medical Center', 'General Hospital', 'Clinic', 'Health Center'].sample}",
    address: "#{Faker::Address.street_address}, #{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip_code}",
    phone: Faker::PhoneNumber.phone_number,
    website: Faker::Internet.url,
    latitude: Faker::Address.latitude,
    longitude: Faker::Address.longitude
  )
end

# Create some availabilities
Doctor.all.each do |doctor|
  rand(3..7).times do |i|
    start_time = Faker::Time.forward(days: rand(1..30), period: :day)
    Availability.create!(
      doctor: doctor,
      start_time: start_time,
      end_time: start_time + rand(1..4).hours
    )
  end
end

# Create some appointments
User.where(id: UserRole.where(role_id: Role.find_by(name: 'patient')).pluck(:user_id)).each do |patient|
  rand(0..3).times do
    doctor = Doctor.all.sample
    availability = doctor.availabilities.sample
    
    Appointment.create!(
      user: patient,
      doctor: doctor,
      hospital: Hospital.all.sample,
      appointment_date: availability.start_time + rand(0..60).minutes,
      status: ['pending', 'confirmed'].sample,
      notes: Faker::Lorem.sentence
    )
  end
end

puts "Seeded #{Role.count} roles, #{User.count} users, #{Doctor.count} doctors, #{Hospital.count} hospitals, #{Availability.count} availabilities, and #{Appointment.count} appointments."