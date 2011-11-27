class Page < ActiveRecord::Base

  include Rails.application.routes.url_helpers # neeeded for _path helpers to work in models
      
  has_paper_trail

  def admin_permalink
    admin_page_path(self)
  end
  
  
end
