class UsersController < ApplicationController
  skip_before_filter :require_login, :only => [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to root_url, :notice => "Account created"
    else
      render :new
    end
  end

  def index
    @users = User.order("status desc")
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    if current_user.email = params[:email]
      current_user.update_attributes(params)
    end
  end

  def edit
    @user = User.find(params[:id])
  end
end
