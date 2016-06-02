require "rails_helper"

shared_context :stub_omniauth do
  background do
    OmniAuth.config.mock_auth[:facebook] = auth_hashie
  end
end

shared_context :stub_not_verified_omniauth do
  background do
    OmniAuth.config.mock_auth[:facebook] = auth_hashie(verified: false)
  end
end
