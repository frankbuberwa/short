class HospitalsController < ApplicationController
  before_action :set_hospital, only: [:show, :edit, :update]
  before_action :authorize_hospital_admin, only: [:edit, :update]
  
  def index
    if params[:latitude] && params[:longitude]
      @hospitals = Hospital.near([params[:latitude], params[:longitude]], 50, units: :km, order: :distance)
    else
      @hospitals = Hospital.all
    end
    
    if params[:search].present?
      @hospitals = @hospitals.where("name ILIKE ?", "%#{params[:search]}%")
    end
    
    @hospitals = @hospitals.page(params[:page]).per(10)
  end

  def new
    @hospital = Hospital.new
  end
  
  def create
    @hospital = current_user.build_hospital(hospital_params)
    
    if @hospital.save
      redirect_to @hospital, notice: 'Hospital was successfully created.'
    else
      render :new
    end
  end
  
  def show
    @hospital = Hospital.includes(doctors: :user).find(params[:id])
  end

  def edit
  end
  
  def update
    if @hospital.update(hospital_params)
      redirect_to @hospital, notice: 'Hospital was successfully updated.'
    else
      render :edit
    end
  end
  
  private
  
  def set_hospital
    @hospital = Hospital.find(params[:id])
  end

  def authorize_hospital_admin
    unless current_user.hospital_admin? && current_user.hospital == @hospital
      redirect_to hospitals_path, alert: 'You are not authorized to perform this action.'
    end
  end
  
  def hospital_params
    params.require(:hospital).permit(:name, :address, :phone, :website)
  end
end
