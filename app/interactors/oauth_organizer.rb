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
    user = current_user || find_user_by_email || find_social_profile_user || build_user
    user ? connect_social_profile(user) : fail_oauth
    user
  end

  private

  def find_user_by_email
    user_by_email if auth_verified?
  end

  def user_by_email
    @user_by_email ||= User.find_by(email: auth["info"]["email"])
  end

  def auth_verified?
    @auth_verified ||= AuthVerificationPolicy.verified?(auth)
  end

  def find_social_profile_user
    social_profile.try(:user)
  end

  def social_profile
    @social_profile ||= SocialProfile.from_omniauth(auth)
  end

  def build_user
    if auth_verified? && user_by_email.nil?
      User.build_from_omniauth(auth)
    end
  end

  def connect_social_profile(user)
    return if social_profile

    user.apply_omniauth(auth)
    user.save
  end

  def fail_oauth
    fail OauthError,
     "Sorry, but yours #{auth.provider.titleize} failed verification.
      Seems like yours #{auth.provider.titleize} account hasn't been verified."
  end
end
