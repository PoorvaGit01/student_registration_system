# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.find_or_create_by(email: 'demoadmin_1@yopmail.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end

student = Student.find_or_initialize_by(email: 'demostudent_1@yopmail.com')
student.name = 'Demo Student 1'
student.dob = '1990-01-01'
student.address = 'Demo Address 1'
student.verified = true
student.password = 'password@123'
student.password_confirmation = 'password@123'
student.save!
                  