class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, :default=>""
      t.string :slug,  :null => false
      t.text :content, :default=>""
      t.integer :author_id
      t.integer :position, :default=>""
      t.string :view_template, :default=>""
      t.boolean :nav, :default=>0

      t.timestamps
    end
  end
end
