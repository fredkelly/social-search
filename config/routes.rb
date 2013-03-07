SocialSearch::Application.routes.draw do
  root to: 'search#new'
  match '/search', to: 'search#show'
end
