class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]
  
  def index
    if current_user.doctor?
      @appointments = current_user.doctor.appointments
    elsif current_user.patient?
      @appointments = current_user.appointments_as_patient
    elsif current_user.hospital_admin?
      @appointments = current_user.hospital.appointments
    else
      @appointments = Appointment.all
    end
    @appointments = @appointments.page(params[:page]).per(10)
  end
  
  def new
    @doctor = Doctor.find(params[:doctor_id])
    @appointment = Appointment.new
  end
  
  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.patient = current_user
    @appointment.status = :pending
    
    if @appointment.save
      redirect_to appointments_path, notice: 'Appointment was successfully created.'
    else
      @doctor = @appointment.doctor
      render :new
    end
  end
  
  def update
    if @appointment.update(appointment_params)
      redirect_to @appointment, notice: 'Appointment was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    @appointment.destroy
    redirect_to appointments_url, notice: 'Appointment was successfully destroyed.'
  end
  
  private
  
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end
  
  def appointment_params
    params.require(:appointment).permit(:doctor_id, :hospital_id, :appointment_date, :notes, :status)
  end
end
