require 'api_constraints'

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, skip: [:registrations]

  resources :users, except: [:show]
  resources :profiles, except: [:show]
  resources :roles, except: [:edit, :update, :show]
  resources :organisations

  root 'welcome#index'

  namespace :api do
    namespace :v1 do
      get "/me", to: "credentials#show"
    end
  end

  get '/status' => 'status#index'
  get '/help', controller: :static, action: :help, as: :help
  get '/maintenance', controller: :static, action: :maintenance, as: :maintenance
  get '/cookies', controller: :static, action: :cookies, as: :cookies
  get '/accessibility', controller: :static, action: :accessibility, as: :accessibility
  get '/terms', controller: :static, action: :terms, as: :terms
  get '/expired', controller: :static, action: :expired, as: :expired

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

      resources :users, only: :me do
        get 'me', on: :collection
      end
    end
  end
end
