require 'sidekiq'

class GoodMorningEmailJob
  include Sidekiq::Worker

  def perform(*args)
    Student.where(verified: true).find_each do |student|
      StudentMailer.good_morning_email(student).deliver_now
    end
  end
end