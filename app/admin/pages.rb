ActiveAdmin.register Page, {:sort_order => :url} do

  config.comments = false #Gets rid of some error
  config.sort_order = 'position_asc'
  config.paginate = false
  menu :priority => 1
  # Attachments
  # When I get to this see this option
  # http://activeadmin.info/docs/3-index-pages/index-as-grid.html
  
  
  filter :title
  filter :content
  filter :view_template
  
  index do
    column "Title" do |page|
      content_tag(:span, link_to(page.title, edit_admin_page_path(page)), :"data-id" => page.id, :class => "page-col")
    end
    
    column :url do |page|
      link_to page.url, page.url, :target => "_blank"
    end
    column :position
    column :view_template
    #column :draft
    #column :private
    default_actions
  end

  collection_action :sort, :method => :post do
    params[:ids].each_with_index do |id, index|
      page = Page.find(id)
      page.update_attribute(:position, index.to_i+1)
    end
    head 200
  end
  
  form do |f|
    f.inputs "Details" do
      f.input :title
      f.input :slug
      f.input :content, :as => :text
      f.input :view_template
      f.input :show_in_nav, :as=>:boolean
      f.input :parent_id, :as => :select, :collection => Page.all(:order => :title)
    end
    
    f.inputs "Additional options &raquo;", :class => "additional-options" do
      f.semantic_fields_for :pageable, f.object.pageable || PageOption.new do |opts|
        opts.inputs :browser_title, :meta_keywords, :meta_description, :javascript
      end
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
    
    def update
      params[:page][:document_ids] ||= [] #Otherwise it won't remove any docs trying to be removed if it's blank
      @page = Page.find(params[:id])
      update!
    end
  end
  
  sidebar :versionate, :partial => "layouts/version", :only => :show
    
end
