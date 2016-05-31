require "rails_helper"

describe ConnectIdentity do
  include_context :auth_hashie

  let(:service) { described_class.new(user, auth_hashie) }

  subject(:connect_social_account) { service.call }

  context "when identity exists" do
    let(:user) { create(:user) }
    let(:user_2) { create(:user) }

    let!(:identity) do
      create(:identity, uid: auth_hashie.uid, provider: auth_hashie.provider, user: user_2)
    end

    it "updates user id" do
      expect { connect_social_account }.to change { identity.reload.user }.from(user_2).to(user)
    end
  end

  context "when identity not exists" do
    let(:user) { create(:user) }

    it "creates related identity" do
      expect { connect_social_account }.to change { user.identities.count }.by(1)
    end
  end

  context "when user email matches with oauth email" do
    let(:user) { create(:user, email: auth_hashie.info.email, confirmed_at: nil) }

    it "confirms user" do
      expect(user.confirmed?).to be_falsey
      connect_social_account
      expect(user.confirmed?).to be_truthy
    end
  end

  context "when user email not matches with oauth email" do
    let(:user) { create(:user, email: "not@matched.email", confirmed_at: nil) }

    it "doesn't confirm user" do
      expect(user.confirmed?).to be_falsey
      connect_social_account
      expect(user.confirmed?).to be_falsey
    end
  end
end
