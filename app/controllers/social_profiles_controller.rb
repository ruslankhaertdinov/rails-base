class SocialProfilesController < ApplicationController
  before_action :authenticate_user!

  expose(:social_profiles) { current_user.social_profiles }
  expose(:social_profile)

  def destroy
    social_profile.destroy
    flash[:notice] = "Successfully destroyed social profile."
    redirect_to edit_user_registration_url
  end
end
