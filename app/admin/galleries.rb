ActiveAdmin.register Page, :as => "Gallery" do

  # config.comments = false #Gets rid of comments error (not sure why that happens though)
  

  # I want to figure out how to hide this, 
  # but still grap the Page.galleries
  scope :galleries, :default => true
  
  form do |f|
    f.inputs "Details" do
      f.input :title
      f.input :slug
      f.input :page_type, :as => :hidden, :value=>"gallery"
      f.input :content, :as => :text
      f.input :view_template
      f.input :show_in_nav, :as=>:boolean, :label => "Show in navigation"
      f.input :draft, :as=>:boolean, :label => "Save as a draft -- not viewable on website"
      f.input :private, :as=>:boolean, :label => "keep private -- hide from normal users"
    end
  
    f.buttons
  end
  
  member_action :history do
    @page = Page.find(params[:id])
    @versions = @page.versions
    render "layouts/history"
  end
  
  controller do
    def show
        @page = Page.find(params[:id])
        @versions = @page.versions 
        @page = @page.versions[params[:version].to_i].reify if params[:version]
        show! #it seems to need this
    end
    
#     def new
#       @page = Page.new(params[:page])
#       #@page.page_type = "gallery"
#       new!
#     end
  end
  
  sidebar :versionate, :partial => "layouts/version", :only => :show
  
    
end
