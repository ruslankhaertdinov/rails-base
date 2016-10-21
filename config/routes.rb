Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations", omniauth_callbacks: "omniauth_callbacks" }
  resources :identities, only: :destroy
  root to: "pages#home"
end
