class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # force session to be created for every user
  before_filter :current_session
  
  # show error messages
  
  class Error < RuntimeError; end
  rescue_from Error, with: :flash_error
  
  private
  
  def flash_error(error)
    flash[:error] = "Sorry, an error occurred - #{error}"
    redirect_to(root_url)
  end
  
  # Get the current user's Session record based on session_id
  def current_session
    @current_session ||= Session.find_or_create_by_request(request)
  end
  
  helper_method :current_session
end
