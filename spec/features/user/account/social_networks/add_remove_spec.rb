require "rails_helper"

feature "Add/Remove social networks" do
  let(:uid) { "12345" }
  let(:user) { create(:user, :confirmed) }
  let(:user_attributes) { user.attributes.slice(:full_name, :email) }
  let(:omniauth_params) { omniauth_mock(provider, uid, user_attributes) }

  before do
    stub_omniauth(provider, omniauth_params)
    stub_devise
    login_as user
    visit edit_user_registration_path
  end

  context "when provider is Facebook" do
    let(:provider) { :facebook }

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

      #click X, expect to delete
    end
  end

  context "when provider is Facebook" do
    let(:provider) { :google_oauth2 }

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
end
