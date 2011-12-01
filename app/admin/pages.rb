ActiveAdmin.register Page do

  config.comments = false #Gets rid of some error
  
  # Create sections on the index screen
  scope :pages, :default => true
  #scope :galleries
  
  # Attachments
  # When I get to this see this option
  # http://activeadmin.info/docs/3-index-pages/index-as-grid.html
  
  
  # Filters
  # TODO: make default filter page_type=="page"
  filter :title
  filter :content
  filter :view_template
  filter :page_type
  
  index do
    column "Title" do |page|
      link_to page.title, admin_page_path(page)
    end
    column :slug
    column :position
    column :view_template
    column :draft
    column :private
    column :created_at
    default_actions
  end
  
  form do |f|
    f.inputs "Details" do
      f.input :title
      f.input :slug
      f.input :content, :as => :text
      f.input :view_template
      f.input :show_in_nav, :as=>:boolean
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
      @page.page_type = "page"
      new!
    end
  end
  
  sidebar :versionate, :partial => "layouts/version", :only => :show
  
    
end
