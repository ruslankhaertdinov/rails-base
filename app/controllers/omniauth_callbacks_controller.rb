class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  expose(:user) { OauthOrganizer.new(auth_hash, current_user).call }

  SocialProfile::PROVIDERS.each do |provider|
    define_method("#{provider}") do
      if user.persisted?
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: "#{auth_hash.provider.titleize}") if is_navigational_format?
      else
        session[:omniauth] = auth_hash.except("extra")
        redirect_to new_user_registration_url
      end
    end
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end
