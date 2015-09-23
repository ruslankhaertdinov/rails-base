class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_callback
  end

  def facebook
    handle_callback
  end

  private

  def handle_callback
    if current_user && social_link
      flash[:notice] = "Social profile already linked."
      redirect_to edit_user_registration_url
    elsif current_user
      current_user.social_links.create(provider: auth.provider, uid: auth.uid)
      flash[:notice] = "Successfully linked social profile."
      redirect_to edit_user_registration_url
    elsif social_link
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, social_link.user)
    else
      user = User.from_omniauth(auth)
      user.social_links.create(provider: auth.provider, uid: auth.uid)
      flash[:notice] = "Signed up successfully."
      sign_in_and_redirect(:user, user)
    end
  end

  def social_link
    @social_link ||= SocialLink.from_omniauth(auth)
  end

  def auth
    request.env["omniauth.auth"]
  end
end
