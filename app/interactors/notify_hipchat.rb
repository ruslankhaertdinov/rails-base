class NotifyHipchat
  attr_reader :feedback
  private :feedback

  ROOM = ENV["HIPCHAT_ROOM"]
  TOKEN = ENV["HIPCHAT_TOKEN"]

  def initialize(feedback)
    @feedback = feedback
  end

  def call
    client[ROOM].send(feedback.name, feedback.message)
  end

  private

  def client
    HipChat::Client.new(TOKEN)
  end
end
