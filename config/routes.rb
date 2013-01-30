SocialSearch::Application.routes.draw do
  get "results/show"

  root to: 'search#index'
  match '/search', to: 'search#create'
  resources :results, only: :show
end
