require "rails_helper"

feature "Detach social account" do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
    create(:identity, user: user, provider: :facebook)
    visit edit_user_registration_path(user)
  end

  scenario "User detaches social account" do
    expect(page).to have_css(".js-identities")

    click_link "Unauthorize?"

    expect(page).to have_text("Identity was successfully destroyed.")
    expect(page).not_to have_css(".js-identities")
  end
end
