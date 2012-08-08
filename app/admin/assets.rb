ActiveAdmin.register Assets do

  scope :all, :default => true
  scope :images
  #scope :pdfs

  index do
    column :id
    column "Title" do |a|
      link_to a.file.original_filename, a.file.url, :target=>:blank
    end
    column "Size" do |a|
      number_to_human_size a.file.size
    end
    column "Filetype" do |a|
      a.file.content_type
    end
    
    column :created_at
    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :title
      f.input :description, :as => :text
      f.input :position
    end
    f.inputs "file" do    
      f.file_field :file
    end
    f.buttons
  end

end
