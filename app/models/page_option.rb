class PageOption < ActiveRecord::Base
  belongs_to :pageable, :polymorphic => true
end
