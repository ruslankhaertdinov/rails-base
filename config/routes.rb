Rails.application.routes.draw do
  devise_for :users

  get 'auth/:provider/callback', to: 'sessions#create_omniauth'
  get 'auth/failure', to: redirect('/')

  root to: "pages#home"
end
