SocialSearch::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  root to: 'search#index'
  match '/search', to: 'search#create'
  resources :results, only: :show
  
  match '/search/comment', to: 'search#comment'
  match '/modals/:modal_id', to: 'search#modals'
  match '/search/:search_id/modals/:modal_id', to: 'search#modals'
end
