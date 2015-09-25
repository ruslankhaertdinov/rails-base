require "rails_helper"

feature "Sign Up" do
  let(:uid) { "12345" }
  let(:user_attributes) { attributes_for(:user).slice(:full_name, :email, :password, :password_confirmation) }
  let(:registered_user) { User.find_by_email(user_attributes[:email]) }
  let(:omniauth_params) { omniauth_mock(provider, uid, user_attributes) }

  before do
    stub_omniauth(provider, omniauth_params)
    stub_devise
  end

  context "when provider is Facebook" do
    let(:provider) { :facebook }

    context "when user and social link not exist" do
      before do
        visit root_path
        click_link "Sign in with Facebook"
      end

      scenario "Visitor signs up through provider" do
        expect(page).to have_content("Signed up successfully.")
        expect(page).to have_text(registered_user.email)
      end
    end

    context "when social link and user exists" do
      let(:user) { FactoryGirl.create(:user, :confirmed, user_attributes) }

      before do
        user.social_links.create(provider: provider, uid: uid)
        visit root_path
        click_link "Sign in with Facebook"
      end

      scenario "Visitor signs in through provider" do
        expect(page).to have_content("Signed in successfully.")
        expect(page).to have_text(registered_user.email)
      end
    end
  end

  context "when provider is Google" do
    let(:provider) { :google_oauth2 }

    context "when user and social link not exist" do
      before do
        visit root_path
        click_link "Sign in with Google"
      end

      scenario "Visitor signs up through provider" do
        expect(page).to have_content("Signed up successfully.")
        expect(page).to have_text(registered_user.email)
      end
    end

    context "when social link and user exists" do
      let(:user) { FactoryGirl.create(:user, :confirmed, user_attributes) }

      before do
        user.social_links.create(provider: provider, uid: uid)
        visit root_path
        click_link "Sign in with Google"
      end

      scenario "Visitor signs in through provider" do
        expect(page).to have_content("Signed in successfully.")
        expect(page).to have_text(registered_user.email)
      end
    end
  end
end
