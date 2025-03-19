require 'sidekiq'

class VerificationEmailWorker
  include Sidekiq::Worker

  def perform(student_id)
    student = Student.find(student_id)
    StudentMailer.verification_confirmation(student).deliver_now
  end
end