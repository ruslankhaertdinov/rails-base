require "rails_helper"

describe FetchUserForOauth do
  let(:uid) { "12345" }
  let(:provider) { "facebook" }
  let(:user_attributes) { user.attributes.slice(:full_name, :email) }
  let(:auth) { omniauth_mock(provider, uid, user_attributes) }
  let(:service) { described_class.new(auth, auth_verified) }

  let(:user_attributes) do
    ActiveSupport::HashWithIndifferentAccess.new(
      attributes_for(:user).slice(:full_name, :email, :password, :password_confirmation)
    )
  end

  subject { service.call }

  context "when user is persisted" do
    let!(:user) { create(:user, user_attributes) }

    context "when auth verified" do
      let(:auth_verified) { true }

      it { is_expected.to eq(user) }
    end

    context "when auth is not verified" do
      let(:auth_verified) { false }

      it { is_expected.not_to eq(user) }
    end
  end

  context "when social_profile persisted" do
    let!(:social_profile) { create(:social_profile, user: user) }

    let(:user) { create(:user, user_attributes) }
    let(:auth_verified) { false }

    it { is_expected.to eq(social_profile.user) }
  end

  context "when user and social profile are not persisted" do
    context "when auth is verified" do
      let(:auth_verified) { true }

      it "returns new user" do
        expect(subject).to be_a_new_record
        expect(subject).to be_kind_of(User)
      end
    end

    context "when auth is not verified" do
      let(:auth_verified) { false }

      it { is_expected.to eq(nil) }
    end
  end
end
