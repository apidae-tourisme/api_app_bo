Rails.application.routes.draw do

  match '*path', :controller => 'application', :action => 'handle_options_request',
        :constraints => {:method => 'OPTIONS'}, via: [:options]

  scope '/api' do
    mount_devise_token_auth_for 'Person', at: 'auth'
    resources :seeds, only: [:index, :show, :create, :edit, :update] do
      get 'details', on: :member
      get 'search', on: :collection
    end
  end

  resources :events
  resources :tasks, path: 'actions'
  resources :ideas
  resources :competences
  resources :schemas
  resources :creative_works
  resources :persons
  resources :concepts
  resources :products
  resources :projects
  resources :organizations

  root to: 'dashboard#index'
end
