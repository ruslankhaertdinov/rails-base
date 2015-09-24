require "rails_helper"

feature "Sign Up" do
  let(:user_attributes) { attributes_for(:user).slice(:full_name, :email, :password, :password_confirmation) }
  let(:registered_user) { User.find_by_email(user_attributes[:email]) }
  let(:uid) { "12345" }

  let(:omniauth_mock) do
    OmniAuth::AuthHash.new(
      {
        provider: provider,
        uid: uid,
        info: {
          name: user_attributes[:full_name],
          email: user_attributes[:email]
        }
      }
    )
  end

  before do
    OmniAuth.config.test_mode                       = true
    OmniAuth.config.mock_auth[:default]             = omniauth_mock
    Rails.application.env_config["omniauth.auth"]   = omniauth_mock
    Rails.application.env_config["devise.mapping"]  = Devise.mappings[:user]
  end

  %w(facebook google_oauth2).each do |provider|
    let(:provider) { provider }

    context "when user and social link not exist" do
      scenario "Visitor signs up through provider" do
        visit root_path
        click_link "Sign in with #{provider_title(provider)}"
        expect(page).to have_content("Signed up successfully.")
        expect(page).to have_text(registered_user.email)
      end
    end

    context "when social link and user exists" do
      let(:user) { FactoryGirl.create(:user, :confirmed, user_attributes) }

      before do
        user.social_links.create(provider: provider, uid: uid)
      end

      scenario "Visitor signs in through provider" do
        visit root_path
        click_link "Sign in with #{provider_title(provider)}"
        expect(page).to have_content("Signed in successfully.")
        expect(page).to have_text(registered_user.email)
      end
    end
  end

  def provider_title(provider)
    if provider == "google_oauth2"
      "Google"
    else
      provider.titleize
    end
  end
end
