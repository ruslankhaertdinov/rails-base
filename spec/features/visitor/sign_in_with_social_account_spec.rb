require "rails_helper"

feature "Sign in with social account" do
  context "when oauth confirmed" do
    include_context :stub_omniauth

    context "when user found by uid" do
      let!(:identity) { create(:identity, user: user) }
      let(:user) { create(:user, :from_auth_hashie) }

      before { click_sign_in_with_fb }

      it_behaves_like "success sign in"
    end

    context "when user found by email" do
      let!(:user) { create(:user, :from_auth_hashie) }

      before { click_sign_in_with_fb }

      it_behaves_like "success sign in"
    end

    context "when user not found" do
      let(:user) { User.last }

      before { click_sign_in_with_fb }

      it_behaves_like "success sign in"
    end
  end

  context "when oauth not confirmed" do
    include_context :stub_not_verified_omniauth

    before { click_sign_in_with_fb }

    scenario "Visitor sees alert message" do
      expect(page).to have_text("Please confirm your facebook account before continuing.")
    end
  end

  def click_sign_in_with_fb
    visit new_user_session_path
    click_link "Sign in with Facebook"
  end
end
