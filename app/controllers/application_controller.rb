class ApplicationController < ActionController::Base  
  protect_from_forgery
  
  protected
  
  def current_user
    return unless session[:user_id]
    @current_user ||= User.find_by_id(session[:user_id])
  end
  
  helper_method :current_user #Makes current_user available in templates

  
  def authenticate
    logged_in? ? true : access_denied
  end
  
  def logged_in?
    (current_user.is_a? User) && !(current_user.disabled?)
  end
  
#  def session_current?
#    session[:expires].nil? && session[:expires] > Time.now
#  end
  
  def admin
    current_user.admin? ? true : access_denied
  end
  
  def manager
    (current_user.manager? || current_user.admin?) ? true : access_denied
  end
  
  helper_method :logged_in?
  
  def access_denied
    redirect_to logout_path
  end
  
end
