class SocialLinksController < ApplicationController
  before_action :authenticate_user!

  expose(:social_links) { current_user.social_links }
  expose(:social_link)

  def index
  end

  def destroy
    social_link.destroy
    flash[:notice] = "Successfully destroyed social link."
    redirect_to social_links_url
  end
end
