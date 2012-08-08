class Assets < ActiveRecord::Base
  has_attached_file :file

  scope :images, where("file_content_type LIKE '%image%'")
  scope :pdfs, where("file_content_type LIKE '%pdf%")


end
