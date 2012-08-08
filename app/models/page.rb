class Page < ActiveRecord::Base

  include Rails.application.routes.url_helpers # neeeded for _path helpers to work in models
      
  has_paper_trail
  has_many :assets, :dependent => :destroy
  accepts_nested_attributes_for :assets, :allow_destroy => true


  before_validation :check_slug

  scope :galleries, where(:page_type => "gallery")
  scope :pages, where(:page_type => "page")


  def admin_permalink
    admin_page_path(self)
  end
  
  private

  def check_slug
    self.slug = title if slug.blank?
    self.slug = title.strip.downcase.tr_s('^[a-z0-9]', '-')
  end

  
end
