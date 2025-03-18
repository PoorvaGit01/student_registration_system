class GoodMorningEmailJob < ApplicationJob
  queue_as :default

  def perform
    Student.where(verified: true).find_each do |student|
      StudentMailer.good_morning_email(student).deliver_now
    end
  end
end