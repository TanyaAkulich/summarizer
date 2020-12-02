class CreateUploadedFile < ActiveRecord::Migration[5.2]
  def change
    create_table :uploaded_files do |t|
      t.string :file_name, null: false, unique: true

      t.attachment :file
    end
  end
end
