Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: "users/registrations" }

  resources :social_links, only: %i(destroy)
  root to: "pages#home"
end
