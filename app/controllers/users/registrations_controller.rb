class Users::RegistrationsController < Devise::RegistrationsController
  expose(:social_links) { current_user.social_links if current_user }
end
