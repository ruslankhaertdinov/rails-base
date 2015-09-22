class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    handle_callback
  end

  def facebook
    handle_callback
  end

  private

  def social_link
    @social_link ||= SocialLink.from_omniauth(omniauth).first
  end

  def omniauth
    request.env["omniauth.auth"]
  end

  def handle_callback
    if current_user && social_link
      flash[:notice] = "Social link already created."
      redirect_to social_links_url
    elsif current_user
      current_user.social_links.create(provider: omniauth.provider, uid: omniauth.uid)
      flash[:notice] = "Successfully created social link."
      redirect_to social_links_url
    elsif social_link
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, social_link.user)
    else
      user = User.new.apply_omniauth(omniauth)
      flash[:notice] = "Signed up successfully."
      sign_in_and_redirect(:user, user)
    end
  end
end
