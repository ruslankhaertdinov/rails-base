require "rails_helper"

describe NotifyHipchat do
  let(:feedback) { build(:feedback) }
  let(:service) { described_class.new(feedback) }

  before do
    stub_const("NotifyHipchat::TOKEN", "123456abc")
    stub_const("NotifyHipchat::ROOM", "1111")
  end

  it "sends notification to Hipchat" do
    expect(HipChat::Client).to receive_message_chain(:new, :[], :send)
    service.call
  end
end
