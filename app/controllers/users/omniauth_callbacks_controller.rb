class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    if social_link
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, social_link.user)
    elsif current_user
      current_user.social_links.create(provider: omniauth.provider, uid: omniauth.uid)
      flash[:notice] = "Successfully created social link."
      redirect_to social_links_url
    else
      user = User.new.apply_omniauth(omniauth)
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, user)
    end
  end

  private

  def social_link
    @social_link ||= SocialLink.from_omniauth(omniauth).first
  end

  def omniauth
    request.env["omniauth.auth"]
  end
end
