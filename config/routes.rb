Rails.application.routes.draw do

  match '*path', :controller => 'application', :action => 'handle_options_request',
        :constraints => {:method => 'OPTIONS'}, via: [:options]

  scope '/api' do
    mount_devise_token_auth_for 'Person', at: 'auth'
    match 'graph/node/:id', to: 'graph#node', via: :get
    match 'graph/details/:id', to: 'graph#details', via: :get
    match 'graph/nodes', to: 'graph#nodes', via: :get
    match 'graph/search', to: 'graph#search', via: :get
  end

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
