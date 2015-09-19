class SessionsController < ApplicationController
  def create_omniauth
    user = User.from_omniauth(env["omniauth.auth"])
    sign_in user, scope: :user
    redirect_to root_path
  end
end
