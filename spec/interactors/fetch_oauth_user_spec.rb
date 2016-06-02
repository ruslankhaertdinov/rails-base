require "rails_helper"

describe FetchOauthUser do
  let(:service) { described_class.new(auth_hashie) }

  subject(:fetched_user) { service.call }

  context "when identity exists" do
    let!(:identity) { create(:identity, uid: auth_hashie.uid, provider: auth_hashie.provider) }

    it { is_expected.to eq(identity.user) }
  end

  context "when identity not exists" do
    context "when user exists" do
      let(:user) { build(:user) }

      before do
        allow(FindUserByEmail).to receive_message_chain(:new, :call).and_return(user)
      end

      it "fetches user by email" do
        expect(FindUserByEmail).to receive_message_chain(:new, :call)
        expect(fetched_user).to eq(user)
      end
    end

    context "when user not exists" do
      let(:user) { build(:user) }

      before do
        allow(CreateUserFromAuth).to receive_message_chain(:new, :call).and_return(user)
      end

      it "creates new one" do
        expect(CreateUserFromAuth).to receive_message_chain(:new, :call)
        expect(fetched_user).to eq(user)
      end
    end
  end
end
