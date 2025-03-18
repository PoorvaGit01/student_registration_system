namespace :email do
  desc "Send Good Morning emails to all verified students"
  task send_good_morning_emails: :environment do
    GoodMorningEmailJob.perform_later
  end

  desc "Send Birthday emails to all verified students"
  task send_birthday_emails: :environment do
    BirthdayEmailJob.perform_later
  end
end