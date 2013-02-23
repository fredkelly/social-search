SocialSearch::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  root to: 'search#index'
  match '/search', to: 'search#create'
  match '/search/comment', to: 'search#comment'
  resources :results, only: :show
end
