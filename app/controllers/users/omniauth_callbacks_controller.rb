class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # omniauth = request.env["omniauth.auth"]
    # user = User.from_omniauth(omniauth)
    # flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
    # sign_in_and_redirect user, event: :authentication

    omniauth = request.env["omniauth.auth"]
    social_link = SocialLink.from_omniauth(omniauth).first
    if social_link
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, social_link.user)
    elsif current_user
      current_user.social_links.create(provider: omniauth.provider, uid: omniauth.uid)
      flash[:notice] = "Successfully created social link."
      redirect_to social_links_url
    else
      user = User.new
      user.apply_omniauth(omniauth)
      user.skip_confirmation!
      user.save
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, user)
    end
  end
end
