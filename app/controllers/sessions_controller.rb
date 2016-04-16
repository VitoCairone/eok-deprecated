class SessionsController < ApplicationController
  def create
    begin
      @user_auth = UserAuth.from_omniauth(request.env['omniauth.auth'])
      @user = User.from_user_auth(@user_auth)
      session[:user_auth_id] = @user_auth.id
      session[:session_token] = @user.session_token
      flash[:success] = "Welcome, #{@user.name}!"
    rescue
      flash[:warning] = "Sorry, there was an error while trying to authenticate you."
    end
    redirect_to root_path
  end

  def destroy
    # current_user and current_user_auth SHOULD always occur together
    if current_user || current_user_auth
      user = current_user

      # delete session_token and user_auth_id on this client so the 
      # client is no longer logged in.
      session.delete(:user_auth_id)
      session.delete(:session_token)

      # To invalidate all other clients for this user on Logout,
      # assign the database session_token to a 60-character garbage string.
      # This also makes it easy to distinguish logged in and logged out
      # users because logged in users have 64-character strings.
      if user and not user.single_client_logout?
        user.session_token = SecureRandom.urlsafe_base64(60)
        user.save!
      end

      flash[:success] = 'You are now logged out, come back soon!'
    end
    redirect_to root_path
  end

end
