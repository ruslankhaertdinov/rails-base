class CreateUserFromAuth
  attr_reader :auth
  private :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    user = User.new(user_params)
    user.skip_confirmation!
    user.save!
    user
  end

  private

  def user_params
    password = Devise.friendly_token.first(8)
    {
      email: auth.info.email,
      full_name: auth.info.name,
      password: password,
      password_confirmation: password
    }
  end
end
