class SocialLinksController < ApplicationController
  before_action :authenticate_user!

  # TODO: improve expose
  expose(:social_links) { current_user.social_links }

  def index
  end

  def destroy
  end
end
