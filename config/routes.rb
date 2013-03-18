SocialSearch::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  root to: 'search#index'
  
  resources :results, only: :show
  match '/search', to: 'search#create'
  match '/search/comment', to: 'search#comment'
  match '/search/recents', to: 'search#recents'
  match '/modals/:modal_id', to: 'search#modals'
  match '/search/:search_id/modals/:modal_id', to: 'search#modals'
end
