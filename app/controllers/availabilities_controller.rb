# app/controllers/availabilities_controller.rb
class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: [:show, :edit, :update, :destroy]
  before_action :ensure_doctor, only: [:new, :create, :edit, :update, :destroy]

  def index
    @availabilities = current_user.doctor.availabilities.order(start_time: :asc)
    @upcoming_availabilities = @availabilities.upcoming
    @past_availabilities = @availabilities.past
  end

  def show
  end

  def new
    @availability = current_user.doctor.availabilities.new
    # Default to next available hour
    @availability.start_time = Time.current.beginning_of_hour + 1.hour
    @availability.end_time = @availability.start_time + 1.hour
  end

  def edit
  end

  def create
    @availability = current_user.doctor.availabilities.new(availability_params)

    if @availability.save
      redirect_to availabilities_path, notice: 'Availability was successfully created.'
    else
      render :new
    end
  end

  def update
    if @availability.update(availability_params)
      redirect_to availabilities_path, notice: 'Availability was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @availability.destroy
    redirect_to availabilities_url, notice: 'Availability was successfully removed.'
  end

  private

  def set_availability
    @availability = Availability.find(params[:id])
  end

  def ensure_doctor
    unless current_user.doctor?
      redirect_to root_path, alert: "You don't have permission to perform this action."
    end
  end

  def availability_params
    params.require(:availability).permit(:start_time, :end_time)
  end
end