class FeedbacksController < ApplicationController
  expose(:feedback) { Feedback.new(feedback_attributes) }

  def new
  end

  def create
    dispatch_feedback if feedback.save
    respond_with(feedback, location: root_path)
  end

  private

  def feedback_attributes
    params.fetch(:feedback, {}).permit(:email, :name, :message, :phone)
  end

  def dispatch_feedback
    ApplicationMailer.feedback(feedback).deliver_now!
    NotifyHipchat.new(feedback).call
  end
end
