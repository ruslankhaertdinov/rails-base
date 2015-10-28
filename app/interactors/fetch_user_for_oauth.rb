class FetchUserForOauth
  attr_reader :auth, :auth_verified
  private :auth, :auth_verified

  def initialize(auth, auth_verified)
    @auth = auth
    @auth_verified = auth_verified
  end

  def call
    find_user_by_email || find_social_profile_user || build_user
  end

  private

  def find_user_by_email
    user_by_email if auth_verified
  end

  def user_by_email
    @user_by_email ||= User.find_by(email: auth["info"]["email"])
  end

  def find_social_profile_user
    social_profile.try(:user)
  end

  def social_profile
    SocialProfile.from_omniauth(auth)
  end

  def build_user
    if auth_verified && user_by_email.nil?
      User.build_from_omniauth(auth)
    end
  end
end
