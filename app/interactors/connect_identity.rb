class ConnectIdentity
  attr_reader :user, :auth
  private :user, :auth

  def initialize(user, auth)
    @user = user
    @auth = auth
  end

  def call
    update_or_create_identity
    confirm_user
  end

  private

  def update_or_create_identity
    identity.present? ? update_identity : create_identity
  end

  def identity
    @identity ||= Identity.from_omniauth(auth)
  end

  def update_identity
    identity.update_attribute(:user, user)
  end

  def create_identity
    user.identities.create!(provider: auth.provider, uid: auth.uid)
  end

  def confirm_user
    user.confirm if user.email == auth.info.email
  end
end
