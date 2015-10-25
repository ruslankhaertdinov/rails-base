class OauthOrganizer
  attr_reader :auth, :current_user
  private :auth, :current_user

  def initialize(auth, current_user)
    @auth = auth
    @current_user = current_user
  end

  def call
    if current_user && social_profile.present?
      current_user
    elsif current_user && social_profile.nil? && auth_verified?
      current_user.social_profiles.create!(uid: auth.uid, provider: auth.provider)
      current_user
    elsif !current_user && social_profile.present?
      social_profile.user
    else
      user_from_omniauth.apply_omniauth(auth)
      user_from_omniauth.save
      user_from_omniauth
    end
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
end
