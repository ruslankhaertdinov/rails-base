class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  expose(:user) { OauthOrganizer.new(auth_hash, current_user).call }

  SocialProfile::PROVIDERS.each do |provider|
    define_method("#{provider}") do
      begin
        handle_user
      rescue OauthOrganizer::OauthError => e
        handle_error(e)
      end
    end
  end

  def after_sign_in_path_for(_resource)
    edit_user_registration_path
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end

  def handle_user
    if user.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{auth_hash.provider.to_s.titleize}") if is_navigational_format?
    else
      session[:omniauth] = auth_hash.except("extra")
      redirect_to new_user_registration_url
    end
  end

  def handle_error(e)
    if user_signed_in?
      redirect_to root_path, notice: e.message
    else
      redirect_to new_user_session_path,
                  notice: "Your #{auth_hash.provider.to_s.titleize} account can't be used to sign in. Please verify it via profile page."
    end
  end
end
