class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in successfully"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out successfully"
  end

  def failure
    redirect_to sign_in_url, alert: 'Authentication failed, please try again.'
  end

end
