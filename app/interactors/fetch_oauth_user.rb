class FetchOauthUser
  attr_reader :auth
  private :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    user_found_by_uid || user_found_by_email || new_user
  end

  private

  def user_found_by_uid
    Identity.from_omniauth(auth)&.user
  end

  def user_found_by_email
    FindUserByEmail.new(auth).call
  end

  def new_user
    CreateUserFromAuth.new(auth).call
  end
end
