class CreateStudents < ActiveRecord::Migration[7.1]
  def change
    create_table :students do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password, null: false, default: ""
      t.date :dob
      t.text :address
      t.boolean :verified
      t.integer :status

      t.timestamps
    end
    add_index :students, :email, unique: true
  end
end
