# filepath: /home/developer/student_registration_system/app/workers/registration_email_worker.rb
require 'sidekiq'

class RegistrationEmailWorker
  include Sidekiq::Worker

  def perform(student_id)
    student = Student.find(student_id)
    StudentMailer.registration_confirmation(student).deliver_now
  end
end