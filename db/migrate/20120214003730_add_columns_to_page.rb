class AddColumnsToPage < ActiveRecord::Migration
  def change
    add_column :pages, :lft, :integer
    add_column :pages, :rgt, :integer
    add_column :pages, :parent_id, :integer
    
    # page.url will be the full trailing url (e.g. '/page/sub-page'), versus page.slug (e.g. 'sub-page')
    add_column :pages, :url, :string
  end
end
