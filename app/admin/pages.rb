ActiveAdmin.register Page do

form do |f|

  f.inputs "Details" do
    f.input :title
    f.input :slug
    f.input :content, :as => :text
    f.input :position
    f.input :view_template
  end

  f.buttons
end

#  sidebar :extras do

#  end
  
end
