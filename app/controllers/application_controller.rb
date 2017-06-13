class ApplicationController < ActionController::Base
  before_action :authorize
  protect_from_forgery with: :null_session
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  protected
  def authorize
    unless User.find_by(id: session[:user_id])
      redirect_to login_url, notice: "lol"
    end
  end
end
