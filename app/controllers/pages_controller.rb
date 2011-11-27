class PagesController < ApplicationController

  def show
    params[:slug] ||= 'home'
    @page = Page.find_by_slug(params[:slug])
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
