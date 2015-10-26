class OauthOrganizer
  class OauthError < StandardError
  end

  attr_reader :auth, :current_user
  private :auth, :current_user

  def initialize(auth, current_user)
    @auth = auth
    @current_user = current_user
  end

  def call
    current_user_and_social_profile_exists ||
      current_user_and_new_social_profile ||
      social_profile_exists ||
      new_social_profile
  end

  private

  def social_profile
    @social_profile ||= SocialProfile.from_omniauth(auth)
  end

  def auth_verified?
    @auth_verified ||= AuthVerificationPolicy.verified?(auth)
  end

  def user
    @user ||= User.from_omniauth(auth)
  end

  def current_user_and_social_profile_exists
    current_user if current_user && social_profile
  end

  def current_user_and_new_social_profile
    if current_user && social_profile.nil?
      if auth_verified?
        current_user.social_profiles.create!(uid: auth.uid, provider: auth.provider)
        current_user
      else
        fail_oauth_error
      end
    end
  end

  def social_profile_exists
    social_profile.user if current_user.nil? && social_profile
  end

  def new_social_profile
    if auth_verified?
      user.apply_omniauth(auth)
      user.save
      user
    else
      fail_oauth_error
    end
  end

  def fail_oauth_error
    fail OauthError, "Sorry, but yours #{auth.provider.to_s.titleize} failed verification. \
      Seems like yours #{auth.provider.to_s.titleize} account hasn't been verified."
  end
end
