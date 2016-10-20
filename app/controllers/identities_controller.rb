class IdentitiesController < ApplicationController
  before_action :authenticate_user!

  expose(:identities) { current_user.identities }
  expose(:identity)

  def destroy
    identity.destroy
    respond_with identity, location: edit_user_registration_url
  end
end
