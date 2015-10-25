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
    current_user_and_social_profile_present ||
      current_user_and_new_social_profile ||
      only_social_profile_present ||
      only_new_social_profile
  end

  private

  def social_profile
    @social_profile ||= SocialProfile.from_omniauth(auth)
  end

  def auth_verified?
    AuthVerificationPolicy.verified?(auth)
  end

  def user_from_omniauth
    @user_from_omniauth ||= User.from_omniauth(auth)
  end

  def current_user_and_social_profile_present
    current_user if current_user && social_profile
  end

  def current_user_and_new_social_profile
    if current_user && social_profile.nil?
      if auth_verified?
        current_user.social_profiles.create!(uid: auth.uid, provider: auth.provider)
        current_user
      else
        fail OauthError, "Sorry, but yours #{auth.provider.titleize} failed verification.
          Seems like yours #{auth.provider.titleize} account hasn't been verified."
      end
    end
  end

  def only_social_profile_present
    social_profile.user if current_user.nil? && social_profile
  end

  def only_new_social_profile
    if auth_verified?
      user_from_omniauth.apply_omniauth(auth)
      user_from_omniauth.save
      user_from_omniauth
    else
      fail OauthError, "Sorry, but yours #{auth.provider.titleize} failed verification.
        Seems like yours #{auth.provider.titleize} account hasn't been verified."
    end
  end
end
