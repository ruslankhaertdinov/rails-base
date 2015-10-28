class OauthOrganizer
  class OauthError < StandardError
  end

  attr_reader :auth, :current_user
  private :auth, :current_user

  def initialize(current_user, auth)
    @current_user = current_user
    @auth = auth
  end

  def call
    user.present? ? user.connect_social_profile(auth) : fail_oauth
    user
  end

  private

  def user
    @user ||= current_user || FetchUserForOauth.new(auth, auth_verified?).call
  end

  def auth_verified?
    @auth_verified ||= AuthVerificationPolicy.verified?(auth)
  end

  def fail_oauth
    fail OauthError,
     "Sorry, but yours #{auth.provider.titleize} failed verification.
      Seems like yours #{auth.provider.titleize} account hasn't been verified."
  end
end
