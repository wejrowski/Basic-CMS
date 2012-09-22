class CreatePageOptions < ActiveRecord::Migration
  def change
    create_table :page_options do |t|
      t.references :pageable, :polymorphic => true
      t.string :browser_title
      t.string :meta_keywords
      t.text :meta_description
      t.text :javascript

      t.timestamps
    end
  end
end
