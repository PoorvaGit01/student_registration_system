# filepath: /home/developer/student_registration_system/app/models/student.rb
class Student < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  has_one_attached :photo

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :dob, presence: true
  validates :address, presence: true
  validates :password, presence: true, length: {
    minimum: 5
  }, if: :password

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  after_create :send_registration_email
  after_create :send_email_to_admin, unless: :verified?

  def send_registration_email
    RegistrationEmailWorker.perform_async(self.id)
  end

  def send_email_to_admin
    AdminNotificationWorker.perform_async(self.id)
  end

end