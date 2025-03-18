class AdminMailer < ApplicationMailer
  def new_student_registration(student)
    @student = student
    admin_email = AdminUser.last.email || 'demoadmin_1@yopmail.com'
    mail(to: admin_email, subject: 'New Student Registration')
  end
end