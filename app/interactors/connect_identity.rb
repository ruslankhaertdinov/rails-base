class ConnectIdentity
  attr_reader :user, :auth
  private :user, :auth

  def initialize(user, auth)
    @user = user
    @auth = auth
  end

  def call
    identity.present? ? update_identity : create_identity
    user.confirm if user.email == auth.email
  end

  private

  def identity
    @identity ||= Identity.from_omniauth(auth)
  end

  def update_identity
    # действительно ли мы должны это делать?
    identity.update_attribute(:user, user)
  end

  def create_identity
    user.identities.create!(provider: auth.provider, uid: auth.uid)
  end
end
