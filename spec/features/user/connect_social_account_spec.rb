require "rails_helper"

feature "Connect social account" do
  let!(:user) { create(:user, :from_auth_hashie) }

  context "oauth confirmed" do
    include_context :stub_omniauth

    scenario "User connects social account" do
      click_connect_fb
      expect(page).to have_connected_account("Facebook")
    end
  end

  context "oauth not confirmed" do
    include_context :stub_not_verified_omniauth

    scenario "User views alert message" do
      click_connect_fb
      expect(page).to have_text("Please confirm your Facebook account before continuing.")
    end
  end

  def click_connect_fb
    login_as(user, scope: :user)
    visit edit_user_registration_path(user)
    click_link "Facebook"
  end
end
