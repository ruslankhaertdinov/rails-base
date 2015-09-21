Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :social_links, only: %i(index destroy)
  root to: "pages#home"
end
