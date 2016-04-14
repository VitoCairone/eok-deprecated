class SessionsController < ApplicationController
	def create
		begin
	    @user_auth = UserAuth.from_omniauth(request.env['omniauth.auth'])
	    session[:user_auth_id] = @user_auth.id
	    flash[:success] = "Welcome, #{@user_auth.name}!"
	  rescue
	    flash[:warning] = "There was an error while trying to authenticate you..."
	  end
	  redirect_to root_path
	end

	def destroy
	  if current_user_auth
	    session.delete(:user_auth_id)
	    flash[:success] = 'See you!'
	  end
	  redirect_to root_path
	end

end
