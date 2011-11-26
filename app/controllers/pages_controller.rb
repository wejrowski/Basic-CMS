class PagesController < ApplicationController

  def show
    params[:slug] ||= 'home'
    @page = Page.find_by_slug(params[:slug])
    raise ActiveRecord::RecordNotFound, "Page not found" if @page.nil?

    # Render layout
    # (1) custom page layout
    unless @page.view_template.blank?
			render "pages/templates/#{@page.view_template}"
			#respond_to do |format|
			
				#format.html {render(:template=>"pages/layouts/#{@page.layout}");}
			#end
			
    # (2) Default layout
		else
			  render(:action => 'show');
		end  
  end

end
