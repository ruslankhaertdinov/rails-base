class AuthOrganizer
  attr_reader :auth
  private :auth

  def initialize(auth)
    @auth = auth
  end

  def user
    found_by_uid || found_by_email || new_user
  end

  private

  def found_by_uid
    Identity.from_omniauth(auth).try(:user)
  end

  def found_by_email
    FindUserByEmail.new(auth).call
  end

  def new_user
    CreateUserFromAuth.new(auth).call
  end
end
