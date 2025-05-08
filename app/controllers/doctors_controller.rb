# app/controllers/doctors_controller.rb
class DoctorsController < ApplicationController
  before_action :set_doctor, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authorize_doctor, only: [:new, :create, :edit, :update, :destroy]

  def index
    if params[:latitude] && params[:longitude]
      @doctors = Doctor.near([params[:latitude], params[:longitude]], 50, order: :distance)
    else
      @doctors = Doctor.all
    end
    
    if params[:specialty].present?
      @doctors = @doctors.where("specialty ILIKE ?", "%#{params[:specialty]}%")
    end
    
    @doctors = @doctors.includes(:user).page(params[:page]).per(10)
  end

  def show
    @availabilities = @doctor.availabilities.upcoming
    @hospital_options = Hospital.all.map { |h| [h.name, h.id] }
  end

  def new
    @doctor = current_user.build_doctor
  end

  def edit
  end

  def create
    @doctor = current_user.build_doctor(doctor_params)

    if @doctor.save
      current_user.add_role(:doctor) unless current_user.doctor?
      redirect_to @doctor, notice: 'Doctor profile was successfully created.'
    else
      render :new
    end
  end

  def update
    if @doctor.update(doctor_params)
      redirect_to @doctor, notice: 'Doctor profile was successfully updated.'
    else
      render :edit
    end
  end

  def manage
    @doctors = Doctor.includes(:user).all
    
    if params[:search].present?
      @doctors = @doctors.joins(:user).where(
        "users.first_name ILIKE :search OR users.last_name ILIKE :search OR doctors.specialty ILIKE :search",
        search: "%#{params[:search]}%"
      )
    end
    
    @doctors = @doctors.page(params[:page]).per(20)
  end

  def destroy
    @doctor.destroy
    redirect_to doctors_url, notice: 'Doctor profile was successfully removed.'
  end

  private

  def set_doctor
    @doctor = Doctor.find(params[:id])
  end

  def authorize_doctor
    unless current_user.doctor? || current_user.admin?
      redirect_to root_path, alert: "You don't have permission to perform this action."
    end
  end

  def doctor_params
    params.require(:doctor).permit(:specialty, :license_number, :years_of_experience)
  end
end