class PagesController < ApplicationController

  def show_page
    params[:slug] ||= 'home'
    @page = Page.find_by_slug(params[:slug], :conditions=>{:page_type=>"page"})

    raise ActiveRecord::RecordNotFound, "Page not found" if @page.nil?
    
    # Render custom page layout
    unless @page.view_template.blank?
			render "pages/templates/#{@page.view_template}"

    # Render Default layout
		else
			  render(:action => 'show');
		end

  end
  
  def show_gallery
    @page = Page.find_by_slug(params[:slug], :conditions=>{:page_type=>"gallery"})

    raise ActiveRecord::RecordNotFound, "Page not found" if @page.nil?
    
    # Render custom page layout
    unless @page.view_template.blank?
			render "pages/templates/#{@page.view_template}"

    # Render Default layout
		else
			  render(:action => 'show');
		end
  end
  
end
