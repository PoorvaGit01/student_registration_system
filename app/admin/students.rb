# filepath: /home/developer/student_registration_system/app/admin/students.rb
ActiveAdmin.register Student do
  permit_params :name, :email, :dob, :photo, :address, :verified, :status

  scope :all, default: true
  scope :verified do |students|
    students.where(verified: true)
  end
  scope :unverified do |students|
    students.where(verified: false)
  end

  member_action :verify, method: :put do
    student = Student.find(params[:id])
    student.update(verified: true)
    VerificationEmailWorker.perform_async(student.id)
    redirect_to admin_student_path(student), notice: "Student verified successfully!"
  end

  action_item :verify, only: :show, if: proc { !student.verified? } do
    link_to "Verify Student", verify_admin_student_path(student), method: :put
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :dob, as: :datepicker
      f.input :photo, as: :file, label: 'Photo', hint: f.object.present? && f.object.photo.present? && f.object.photo.attached? ? image_tag(url_for(f.object.photo), width: '20%', height: '20%') : ""
      f.input :address
      f.input :verified
    end
    f.actions
  end

  show do
    attributes_table do 
      row :name
      row :email
      row :dob
      row :photo do |student|
        image_tag student.photo, size: "100x100"
      end
      row :address
      row :verified
    end
  end

  controller do
    def create
      @student = Student.new(permitted_params[:student])
      @student.password = SecureRandom.hex(8)
      super
    end
  end
end