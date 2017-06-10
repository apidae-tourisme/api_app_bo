Rails.application.routes.draw do

  match '*path', :controller => 'application', :action => 'handle_options_request',
        :constraints => {:method => 'OPTIONS'}, via: [:options]

  scope '/api' do
    mount_devise_token_auth_for 'Person', at: 'auth'
    resources :seeds, only: [:index, :show, :create, :edit, :update] do
      get 'details', on: :member
      get 'search', on: :collection
    end
    resources :pictures, only: [:show, :create]
  end

  devise_for :admins, path: 'administration', path_names: {sign_in: 'connexion', sign_out: 'deconnexion'}

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

  get 'import_users', to: 'dashboard#import_users'
  root to: 'dashboard#index'
end
