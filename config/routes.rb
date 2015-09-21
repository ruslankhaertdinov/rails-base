Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  get '/auth/:provider/callback', to: 'social_links#create'
  resources :social_links, only: %i(index create destroy)
  root to: "pages#home"
end
