class IdentitiesController < ApplicationController
  before_action :authenticate_user!

  expose(:identities) { current_user.identities }
  expose(:identity)

  def destroy
    action = indentity.destroy ? :notice : :alert
    flash[action] = t "flash.actions.destroy.#{action}", resource_name: Identity.model_name.human
    redirect_to edit_user_registration_url
  end
end
