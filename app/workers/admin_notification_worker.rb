# filepath: /home/developer/student_registration_system/app/workers/admin_notification_worker.rb
require 'sidekiq'

class AdminNotificationWorker
  include Sidekiq::Worker

  def perform(student_id)
    student = Student.find(student_id)
    AdminMailer.new_student_registration(student).deliver_now
  end
end