class AuthVerificationPolicy
  class OauthError < StandardError
  end

  attr_reader :auth
  private :auth

  def initialize(auth)
    @auth = auth
  end

  def verified?
    send(auth.provider)
  rescue NoMethodError
    fail OauthError, I18n.t("omniauth.verification.not_implemented", kind: auth.provider)
  end

  private

  def facebook
    auth.info.verified? || auth.extra.raw_info.verified?
  end

  def google_oauth2
    auth.extra.raw_info.email_verified?
  end
end
