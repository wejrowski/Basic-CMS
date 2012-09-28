module ApplicationHelper  
  # Display each css body classes if given
  def body_classes
    @body_classes ||=[]
    @body_classes.split(" ") || nil
  end
  
  # Add a class from anywhere in the template to the body css class
  def add_body_class(*class_names)
    @body_classes ||=[]
    @body_classes << class_names
  end
  
  # If on any page templates you can call breadcrumbs(@page) and this will just map out the pages as breadcrumbs
  # Otherwise you'll have to add them manually
  # with add_crumb, then call breadcrumbs
  def breadcrumbs(page = nil)
    @breadcrumbs ||= []
    page.self_and_ancestors.each {|p| add_crumb(p.title.titleize, p.url)} if page
    render :partial => "shared/breadcrumbs", :locals => {:breadcrumbs => @breadcrumbs}
  end
  
  def add_crumb(name, path)
    @breadcrumbs ||= []
    @breadcrumbs << [name, path]
  end
  
  
  def page_title
    # This checks if there is a Page or Location item and uses it's title / browser title
    # Otherwise it'll just default to blank
    obj = nil
    obj = @page unless @page.nil?
    obj = @location unless @location.nil?
    if obj.nil?
      ""
    else
      title ||= obj.title
      title = obj.pageable.browser_title unless (obj.pageable.nil? || obj.pageable.browser_title.empty?)
      "#{title}"
    end
  end
  
  def pageable_head
    unless @pageable.blank?
      render :partial => "shared/pageable_head"
    end
  end
  

  ####################
  # NAVIGATOIN METHODS
  ####################
  def navigation()
    nav_pages = Page.all(:conditions => {:show_in_nav => true}, :order => :position)
    render :partial => "shared/navigation", :locals => { :pages => nav_pages, :check_boolean => :show_in_nav, :show_subnav => true }
  end

  
  ###################
  # Get Page content
  ###################
  def get_content_for(page_slug)
    pg = Page.find_by_slug(page_slug)
    raw pg.content unless pg.blank?
  end

  def footer_info
    get_content_for('footer')
  end

  def footer_address
    get_content_for('footer-addresses')
  end
  
end
