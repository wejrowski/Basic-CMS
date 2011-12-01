class AddDraftAndPrivateToPage < ActiveRecord::Migration
  def change
    add_column :pages, :draft, :boolean, :default=>0
    add_column :pages, :private, :boolean, :default=>0
  end
end
