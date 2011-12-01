class ChangePageColumnName < ActiveRecord::Migration
  def up
    rename_column :pages, :nav, :show_in_nav
  end

  def down
  end
end
