class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  SocialProfile::PROVIDERS.each do |provider|
    define_method(provider.to_s) do
      show_verification_notice and return unless auth_verified?

      current_user ? connect_identity : process_sign_in
    end
  end

  private

  def show_verification_notice
    redirect_to root_path, flash: { error: "Please confirm your #{auth.provider} account before continuing." }
  end

  def auth_verified?
    AuthVerificationPolicy.new(auth).verified?
  end

  def connect_identity
    ConnectIdentity.new(current_user, auth).call
    redirect_to edit_user_registration_path
  end

  def process_sign_in
    user = FetchOauthUser.new(auth).call
    sign_in_and_redirect user, event: :authentication
  end
end
