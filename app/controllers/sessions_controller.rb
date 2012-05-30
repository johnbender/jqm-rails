class SessionsController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create]

  def new; end

  def create
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to session[:intended_path] || root_url, :notice => "Logged in"
      session[:intended_path] = nil
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path, :notice => "Logged out"
  end
end
