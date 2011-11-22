class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def user_for_paper_trail
    admin_user_signed_in? ? current_admin_user : 'Unknown user'
  end
  
end
