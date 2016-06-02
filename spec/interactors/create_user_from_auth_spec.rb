require "rails_helper"

describe CreateUserFromAuth do
  let(:user) { User.last }
  let(:service) { described_class.new(auth_hashie) }
  let(:sent_emails) { ActionMailer::Base.deliveries.count }

  subject { service.call }

  it "creates new confirmed user from auth hash" do
    expect { subject }.to change { User.count }.by(1)
    expect(sent_emails).to eq(0)
    expect(user.email).to eq(auth_hashie.info.email)
    expect(user.full_name).to eq(auth_hashie.info.name)
    expect(user.confirmed?).to be_truthy
  end
end
