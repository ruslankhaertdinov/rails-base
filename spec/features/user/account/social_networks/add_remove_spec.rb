require "rails_helper"

feature "Add/Remove social networks" do
  let(:user) { create(:user, :confirmed) }
  let(:omniauth_mock) { OmniAuth::AuthHash.new(provider: provider, uid: "12345") }

  before do
    stub_omniauth
    login_as user
    visit edit_user_registration_path
  end

  context "when provider is Facebook" do
    let(:provider) { 'facebook' }

    scenario "user adds social network" do
      expect(page).to have_link("Facebook")
      expect(page).not_to have_content("Linked social networks")

      click_link "Facebook"

      expect(page).to have_content("Successfully linked social profile.")
      expect(page).to have_content("Linked social networks")
      expect(page).to have_css(".js-social-links", text: "Facebook")
      expect(page.all("ul.js-social-links li").size).to eq(1)

      click_link "Facebook"

      expect(page).to have_content("Social profile already linked.")
      expect(page.all("ul.js-social-links li").size).to eq(1)
    end
  end

  context "when provider is Facebook" do
    let(:provider) { 'google_oauth2' }

    scenario "user adds social network" do
      expect(page).to have_link("Google")
      expect(page).not_to have_content("Linked social networks")

      click_link "Google"

      expect(page).to have_content("Successfully linked social profile.")
      expect(page).to have_content("Linked social networks")
      expect(page).to have_css(".js-social-links", text: "Google")
      expect(page.all("ul.js-social-links li").size).to eq(1)

      click_link "Google"

      expect(page).to have_content("Social profile already linked.")
      expect(page.all("ul.js-social-links li").size).to eq(1)
    end
  end

  def stub_omniauth
    OmniAuth.config.test_mode                       = true
    OmniAuth.config.mock_auth[provider.to_sym]      = omniauth_mock
    Rails.application.env_config["omniauth.auth"]   = omniauth_mock
    Rails.application.env_config["devise.mapping"]  = Devise.mappings[:user]
  end
end
