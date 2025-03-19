class StudentMailer < ApplicationMailer
  def registration_confirmation(student, st_password)
    @student = student
    @st_password = st_password
    mail(to: @student.email, subject: 'Registration Confirmation')
  end

  def verification_confirmation(student)
    @student = student
    mail(to: @student.email, subject: 'Account Verified')
  end

  def good_morning_email(student)
    @student = student
    mail(to: @student.email, subject: 'Good Morning!')
  end

  def birthday_email(student)
    @student = student
    mail(to: @student.email, subject: 'Happy Birthday!')
  end
end
