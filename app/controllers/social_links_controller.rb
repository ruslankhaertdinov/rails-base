class SocialLinksController < ApplicationController
  before_action :authenticate_user!

  expose(:social_link)

  def destroy
    social_link.destroy
    flash[:notice] = "Successfully destroyed social link."
    redirect_to edit_user_registration_url
  end
end
