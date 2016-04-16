class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  # gives the current user object, based on the client's session_token
  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  # gives the current user_auth object,
  # using the id which is stored in the client's session
  # and corresponds to a particular UserAuth record id. This is rarely
  # useful and not highly secure -- it is provided for utility, but prefer
  # current_user for essentially all purposes
  def current_user_auth
  	@current_user_auth ||= UserAuth.find_by(id: session[:user_auth_id])
  end

  helper_method :current_user
  helper_method :current_user_auth
end
