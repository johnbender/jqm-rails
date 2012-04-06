class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_login
  helper_method :current_user

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    unless current_user
      session[:intended_path] = request.path
      redirect_to new_session_path, :alert => "You must log in to view that page"
    end
  end
end
