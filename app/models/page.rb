class Page < ActiveRecord::Base

  include Rails.application.routes.url_helpers # neeeded for _path helpers to work in models
  
  acts_as_nested_set
  has_paper_trail
  before_save :check_position
  
  has_one :pageable, :class_name => 'PageOption',
          :foreign_key => :pageable_id, :dependent => :destroy,
          :conditions => {:pageable_type => self.name}
  ::PageOption.send :belongs_to, self.name.underscore.gsub('/', '_').to_sym,
                    :class_name => self.name
  accepts_nested_attributes_for :pageable
  
  acts_as_indexed :fields => [:title, :content]
  validates_uniqueness_of :slug

  before_validation :check_if_new, :check_slug_and_url
  after_save :remap_descendant_urls
  
  def admin_permalink
    admin_page_path(self)
  end
  
  def check_position
    if self.position.nil?
      self.position = (Page.maximum(:position) || 0) + 1
    end
  end
  
  def header_title
    (alternate_title unless alternate_title.blank?) || title
  end

  ################################
  # URL CREATION / ROUTING METHODS
  ################################
  # All the funcitonality to create the page trailing page urls

  def check_if_new
    @was_a_new_record = new_record?
    return true
  end

  # Create my url from my slug and parent slugs
  # This has to be called AFTER SAVE.. since it page won't have any ancestors until then.
  def remap_url
    if self.slug == "home"
      self.url = "/"
    else
      self.url = "/"
      # not using 'self.self_and_ancestors' here since for some reason, when it calls self, it uses the attributes before it was changed.
      self.url << self.ancestors.map{|p| p.slug}.join("/")+"/" unless self.ancestors.empty?
      self.url << self.slug
    end
    self.update_column(:url, self.url)
    logger.info "Remapped: #{self.url}"
  end
  
  # Make sure slug is url safe
  def check_slug_and_url
    if needs_rerouting?
      self.slug = title if slug.blank?
      self.slug = self.slug.parameterize
      logger.info "new slug: #{self.slug}"
    end
  end
  
  # If my slug is changed, that means my descendants must have their urls changed to match
  def remap_descendant_urls
    remap_url
    if needs_rerouting?
      self.descendants.each do |p|
        p.remap_url
        p.update_column(:url, p.url)
      end
      logger.info "EVDI::Application.reload_routes!"
      EVDI::Application.reload_routes!
    end
  end
  
  def needs_rerouting?
    logger.info "needs_rerouting?"
    logger.info "-- slug_changed?=#{self.slug_changed?}"
    logger.info "-- self.parent_id_changed?=#{self.parent_id_changed?}"
    logger.info "-- @was_a_new_record = #{@was_a_new_record}"
    if self.slug_changed? || self.parent_id_changed? || @was_a_new_record
      true
    else
      false
    end
  end
      
end
