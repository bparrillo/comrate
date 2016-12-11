class SessionsController < ApplicationController
  skip_before_action :authorize 

  def create
    user = User.find_by(username: params[:session][:username].downcase)

    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "You have successfully logged in"
      redirect_to user

    else
      redirect_to login_url, alert: "Invalid user/password combination"
      #flash.now[:danger] = "There was something wrong with your login information"
    end
  end

  def new

  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have logged out"
    redirect_to root_path
  end

end