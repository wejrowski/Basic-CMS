class Page < ActiveRecord::Base

  include Rails.application.routes.url_helpers # neeeded for _path helpers to work in models
      
  has_paper_trail

  scope :galleries, where(:page_type => "gallery")
  scope :pages, where(:page_type => "page")



  def admin_permalink
    admin_page_path(self)
  end
  
  
end
