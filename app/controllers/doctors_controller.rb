class DoctorsController < ApplicationController
  before_action :set_doctor, only: [:show]
  
  def index
    if params[:latitude] && params[:longitude]
      @doctors = Doctor.near([params[:latitude], params[:longitude]], 50, units: :km, order: :distance)
    else
      @doctors = Doctor.all
    end
    @doctors = @doctors.page(params[:page]).per(10)
  end
  
  def show
  end
  
  private
  
  def set_doctor
    @doctor = Doctor.find(params[:id])
  end
end
