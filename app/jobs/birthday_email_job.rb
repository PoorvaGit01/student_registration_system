require 'sidekiq'

class BirthdayEmailJob
  include Sidekiq::Job

  def perform(*args)
    today = Date.today
    Student.where(verified: true, dob: today).find_each do |student|
      StudentMailer.birthday_email(student).deliver_now
    end
  end
end