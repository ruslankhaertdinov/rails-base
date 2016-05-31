require "rails_helper"

describe FetchOauthUser do
  include_context :auth_hashie

  let(:service) { described_class.new(auth_hashie) }

  subject { service.call }

  context "when identity exists" do
    let!(:identity) { create(:identity, uid: auth_hashie.uid, provider: auth_hashie.provider) }

    it { is_expected.to eq(identity.user) }
  end

  context "when identity not exists" do
    context "when user exists" do
      let!(:user) { create(:user, :from_auth_hashie) }

      it "creates related identity" do
        expect { subject }.to change { user.identities.count }.by(1)
        expect(subject).to eq(user)
      end
    end

    context "when user not exists" do
      it "creates new one" do
        expect { subject }.to change { User.count }.by(1)
      end
    end
  end
end
