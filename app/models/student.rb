# filepath: /home/developer/student_registration_system/app/models/student.rb
class Student < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  has_one_attached :photo

  validate :photo_format

  

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :dob, presence: true
  validates :address, presence: true
  validates :password, presence: true, length: {
    minimum: 6
  }, if: -> { password.present? }

  enum status: { pending: 0, accepted: 1, rejected: 2 }

  after_create :send_registration_email
  after_create :send_email_to_admin, unless: :verified?


  def self.import_from_csv(file_path)
    errors = []
    ActiveRecord::Base.transaction do
      CSV.foreach(file_path, headers: true).with_index(1) do |row, line_number|
        student = Student.new(email: row['email'])
        student.assign_attributes(
          name: row['name'],
          dob: row['dob'],
          address: row['address'],
          verified: row['verified'] == 'true',
          password: row['password'] || SecureRandom.hex(8)
        )
  
        unless student.save
          unique_errors = student.errors.full_messages.uniq
          errors << "Line #{line_number}: #{student.email} - #{unique_errors.join(', ')}"
        end
      end
      if errors.present?
        raise ActiveRecord::Rollback # Rollback the transaction if any record fails
      end
    end
    errors
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << %w[name dob email address verified]
      all.each do |student|
        csv << [student.name, student.dob, student.email, student.address, student.verified]
      end
    end
  end

  def send_registration_email
    RegistrationEmailWorker.perform_async(self.id)
  end

  def send_email_to_admin
    AdminNotificationWorker.perform_async(self.id)
  end

  private

  def photo_format
    return unless photo.attached?

    if photo.blob.content_type.start_with?('image/')
      acceptable_types = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']
      unless acceptable_types.include?(photo.blob.content_type)
        errors.add(:photo, 'must be a JPEG, JPG, PNG, or GIF')
      end
    else
      errors.add(:photo, 'must be an image')
    end
  end

end