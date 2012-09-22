class PagesController < ApplicationController

  def show
    logger.info "PAGES#SHOW id=#{params[:page_id]}"
    @page = Page.find(params[:page_id])
    # logger.info "PAGES#SHOW url=#{params[:url]}"
    # @page = Page.find_by_url("/"+params[:url])
    raise ActiveRecord::RecordNotFound, "Page not found" if @page.nil?
    @pageable = @page.pageable
    # Render custom page layout
    unless @page.view_template.blank?
			render "pages/templates/#{@page.view_template}"

    # Render Default layout
		else
			  render(:action => 'show');
		end
  end

  def preview
    if params[:id]
      @page = Page.find(params[:id])
      @page.attributes = params[:page]
    else
      @page = Page.new(params[:page])
      @page.children.build
    end
    @pageable = @page.pageable    
    # Render custom page layout
    unless @page.view_template.blank?
			render "pages/templates/#{@page.view_template}"
    # Render Default layout
		else
		  render(:action => 'show')
		end
  end
    
end
