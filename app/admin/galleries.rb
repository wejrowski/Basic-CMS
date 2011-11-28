ActiveAdmin.register Page, :as => "Gallery" do

#  config.comments = false #Gets rid of some error
  
  # Create sections on the index screen
  #scope :pages, :default => true
  scope :galleries, :default => true
  
  
  
  form do |f|
    f.inputs "Details" do
      f.input :title
      f.input :slug
      f.input :page_type#, :as => :hidden
      f.input :content, :as => :text
      f.input :position
      f.input :view_template
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
    
    def new
      @page = Page.new(params[:page])
      @page.page_type = "gallery"
      new!
    end
  end
  
  sidebar :versionate, :partial => "layouts/version", :only => :show
  
    
end
