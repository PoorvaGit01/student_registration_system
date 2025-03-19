# filepath: /home/developer/student_registration_system/app/admin/students.rb
ActiveAdmin.register Student do
  permit_params :name, :email, :dob, :photo, :address, :verified, :status

  # Add bulk import action
  action_item :import_students, only: :index do
    link_to 'Import Students', new_import_admin_students_path
  end

  action_item :export_students, only: :index do
    link_to 'Export Students', export_admin_students_path(format: :csv)
  end

  collection_action :new_import, method: :get do
    # Render the upload form
  end

  collection_action :import, method: :post do
    if params[:file].present?
      begin
        errors = Student.import_from_csv(params[:file].path)
  
        if errors.empty?
          redirect_to admin_students_path, notice: 'Students imported successfully!'
        else
          # Format errors with <br> tags for HTML rendering
          error_message = "Some students could not be imported: #{errors.join(', ')}"
          redirect_to new_import_admin_students_path, alert: error_message.html_safe
        end
      rescue => e
        redirect_to new_import_admin_students_path, alert: "Error importing students: #{e.message}"
      end
    else
      redirect_to new_import_admin_students_path, alert: 'No file selected!'
    end
  end

  collection_action :sample_csv, method: :get do
    file_path = Rails.root.join('lib', 'sample_student.csv')
    if File.exist?(file_path)
      send_file file_path, filename: 'sample_student.csv', type: 'text/csv', disposition: 'attachment'
    else
      redirect_to new_import_admin_students_path, alert: 'Sample CSV file not found.'
    end
  end
  
  collection_action :export, method: :get do
    @students = Student.all
    respond_to do |format|
      format.csv do
        headers['Content-Disposition'] = 'attachment; filename="students.csv"'
        render plain: Student.to_csv
      end
    end
  end

  scope :all, default: true
  scope :verified do |students|
    students.where(verified: true)
  end
  scope :unverified do |students|
    students.where(verified: false)
  end

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :dob
    column :photo do |student|
      image_tag student.photo, size: "50x50" if student.photo.attached?
    end
    column :address
    column :verified
    actions
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
        image_tag student.photo, size: "100x100" if student.photo.attached?
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