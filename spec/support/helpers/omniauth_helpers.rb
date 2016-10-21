module OmniauthHelpers
  def auth_hashie(verified: true)
    OmniAuth::AuthHash.new(
      provider: "facebook",
      uid: "123545",
      info: {
        email: "joe@bloggs.com",
        name: "Joe Bloggs",
        verified: verified
      },
      extra: {
        raw_info: {
          email: "joe@bloggs.com",
          name: "Joe Bloggs",
          verified: verified,
          email_verified: verified
        }
      }
    )
  end
end

RSpec.configure do |config|
  config.include OmniauthHelpers
end
