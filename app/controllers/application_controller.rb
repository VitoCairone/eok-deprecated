class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  # gives the current user_auth id, which is stored in the client's session,
  # and corresponds to a particular UserAuth record id. This is rarely
  # useful and not highly secure -- it is provided for utility, but prefer
  # current_user for essentially all purposes
  def current_user_auth
  	@current_user_auth ||= UserAuth.find_by(id: session[:user_auth_id])
  end

  helper_method :current_user_auth
end
