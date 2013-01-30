SocialSearch::Application.routes.draw do
  root to: 'search#index'
  match '/search', to: 'search#create'
end
