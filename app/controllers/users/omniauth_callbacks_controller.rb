module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      handle_callback
    end

    def facebook
      handle_callback
    end

    private

    def handle_callback
      if current_user && social_link
        when_current_user_and_social_link
      elsif current_user
        when_current_user
      elsif social_link
        when_social_link
      else
        when_first_visit
      end
    end

    def social_link
      @social_link ||= SocialLink.from_omniauth(auth)
    end

    def auth
      request.env["omniauth.auth"]
    end

    def when_current_user_and_social_link
      flash[:notice] = "Social profile already linked."
      redirect_to edit_user_registration_url
    end

    def when_current_user
      current_user.social_links.create(provider: auth.provider, uid: auth.uid)
      flash[:notice] = "Successfully linked social profile."
      redirect_to edit_user_registration_url
    end

    def when_social_link
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, social_link.user)
    end

    def when_first_visit
      user_from_omniauth.social_links.create(provider: auth.provider, uid: auth.uid)
      flash[:notice] = "Signed up successfully."
      sign_in_and_redirect(:user, user_from_omniauth)
    end

    def user_from_omniauth
      @user_from_omniauth ||= User.from_omniauth(auth)
    end
  end
end
