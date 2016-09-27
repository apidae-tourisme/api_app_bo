Rails.application.routes.draw do

  match '*path', :controller => 'application', :action => 'handle_options_request',
        :constraints => {:method => 'OPTIONS'}, via: [:options]

  match 'graph/node/:id', to: 'graph#node', via: :get
  match 'graph/nodes', to: 'graph#nodes', via: :get

  resources :events
  resources :tasks
  resources :ideas
  resources :competences
  resources :schemas
  resources :creative_works
  resources :people
  resources :concepts
  resources :products
  resources :projects
  resources :organizations

  root to: 'dashboard#index'
end
