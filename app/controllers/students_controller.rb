# filepath: /home/developer/student_registration_system/app/controllers/students_controller.rb
class StudentsController < ApplicationController
  before_action :authenticate_student!, only: [:show, :index]

  def index
    @students = [current_student]
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      StudentMailer.registration_confirmation(@student).deliver_now
      AdminMailer.new_student_registration(@student).deliver_now
      redirect_to @student, notice: 'Registration successful. Admin will verify your details soon.'
    else
      render :new
    end
  end

  def show
    @student = Student.find(params[:id])
  end

  private

  def student_params
    params.require(:student).permit(:name, :email, :password, :dob, :photo, :address)
  end
end