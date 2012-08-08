class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :title
      t.text :description
      t.integer :position
      t.integer :page_id

      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.datetime :file_updated_at
      
      t.timestamps
    end
  end
end
