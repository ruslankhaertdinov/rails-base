class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  SocialProfile::PROVIDERS.each do |provider|
    define_method(provider.to_s) do
      current_user ? connect_social_profile : handle_sign_in
    end
  end

  private

  def handle_sign_in
    auth_verified? ? handle_verified_auth : handle_not_verified_auth
  end

  def auth_verified?
    AuthVerificationPolicy.new(auth).verified?
  end

  def handle_verified_auth
    user = AuthOrganizer.new(auth).user
    sign_in_and_redirect user, event: :authentication
  end

  def handle_not_verified_auth
    redirect_to root_path, flash: { notice: "Please confirm your #{auth.provider} account before continuing." }
  end
end
