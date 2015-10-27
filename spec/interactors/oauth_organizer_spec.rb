require "rails_helper"

describe OauthOrganizer do
  let(:provider) { "facebook" }
  let(:uid) { "12345" }
  let(:omniauth_params) { omniauth_mock(provider, uid, user_attributes) }
  let(:service) { described_class.new(omniauth_params, current_user) }

  let(:user_attributes) do
    ActiveSupport::HashWithIndifferentAccess.new(
      attributes_for(:user).slice(:full_name, :email, :password, :password_confirmation)
    )
  end

  subject { service.call }

  before do
    stub_omniauth(provider, omniauth_params)
  end

  context "when current_user and social_profile present" do
    let!(:current_user) { create(:user) }

    before { create(:social_profile, uid: uid, provider: provider) }

    it { is_expected.to eq(current_user) }
  end

  context "when current_user present, but social_profile do not" do
    before do
      allow(AuthVerificationPolicy).to receive(:verified?).and_return(verified)
    end

    let!(:current_user) { create(:user) }

    context "when auth hash is verified" do
      let(:verified) { true }

      it { is_expected.to eq(current_user) }

      it "creates social_profile for current_user" do
        expect { subject }.to change { current_user.social_profiles.count }.by(1)
      end
    end

    context "when auth info is not verified" do
      let(:verified) { false }

      it "fails OauthError" do
        expect { subject }.to raise_error(OauthOrganizer::OauthError)
      end
    end
  end

  context "when current_user is nil, but social_profile exists" do
    let(:current_user) { nil }
    let(:user) { create(:user) }

    before { create(:social_profile, uid: uid, provider: provider, user: user) }

    it { is_expected.to eq(user) }
  end

  context "when current_user nil and social_profile is not exist" do
    let(:current_user) { nil }

    before do
      allow(AuthVerificationPolicy).to receive(:verified?).and_return(verified)
    end

    context "when auth info is verified" do
      let(:verified) { true }
      let(:last_social_profile) { SocialProfile.last }

      context "when user is persisted" do
        before do
          create(:user, user_attributes)
        end

        it "creates new social_profile" do
          expect { subject }.to change { SocialProfile.count }.by(1)
        end

        it { is_expected.to eq(last_social_profile.user) }
      end

      context "when user is not persisted" do
        it "does not create social_profile" do
          expect { subject }.not_to change { SocialProfile.count }
        end

        it "does not save user" do
          expect { subject }.not_to change { User.count }
        end
      end
    end

    context "when auth info is not verified" do
      let(:verified) { false }

      it "fails OauthError" do
        expect { subject }.to raise_error(OauthOrganizer::OauthError)
      end
    end
  end
end
