class DashboardController < ApplicationController
  def show
    if current_user.admin?
      @users = User.count
      @doctors = Doctor.count
      @hospitals = Hospital.count
      @appointments = Appointment.count
    elsif current_user.doctor?
      @upcoming_appointments = current_user.doctor.appointments.upcoming.limit(5)
      @availabilities = current_user.doctor.availabilities.upcoming.limit(5)
    elsif current_user.patient?
      @upcoming_appointments = current_user.appointments_as_patient.upcoming.limit(5)
      @nearby_doctors = Doctor.near([current_user.latitude, current_user.longitude], 50).limit(5) if current_user.latitude.present?
    elsif current_user.hospital_admin?
      @hospital = current_user.hospital
      @doctors = @hospital.doctors.count
      @appointments = @hospital.appointments.upcoming.count
    end
  end
end
