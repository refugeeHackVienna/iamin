Rails.application.routes.draw do
  namespace :ngos do
    resources :events do
      member do
        post 'publish'
        get :cal
      end
    end

    resources :ongoing_events do
      post :publish, on: :member
      get :renew, on: :member
    end
  end

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks' }
  devise_for :ngos, controllers: {
    confirmations: 'ngos/confirmations',
    passwords: 'ngos/passwords',
    registrations: 'ngos/registrations',
    sessions: 'ngos/sessions',
    unlocks: 'ngos/unlocks' }


  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [] do
        collection do
          post 'login'
          delete 'unregister'
          get 'logout'
          delete 'logout'
          post 'change_password'
          post 'send_reset'
          post 'resend_confirmation'
          post 'update_profile'
        end
      end

      resources :languages, only: [:index]
      resources :abilities, only: [:index]

      devise_scope :user do
        post "/users/register"=> "registrations#create"
      end

      resources :events, only: [:show, :index]

      resources :shifts, only: [] do
        collection do
          post 'opt_in'
          post 'opt_out'
        end
      end
    end
  end

  resources :events,         only: [:index, :show]
  resources :ongoing_events, only: [:index, :show] do
    post   :opt_in,  on: :member
    delete :opt_out, on: :member
  end

  resources :shifts, only: [:show] do
    post :opt_in
    delete :opt_out
    get :cal
  end

  resource :schedule, only: :show

  authenticated :user do
    root 'events#index'
  end
  authenticated :ngo do
    root 'ngos/events#index'
  end

  get 'terms_and_conditions', to: 'pages#terms_and_conditions'
  get 'how_to', to: 'pages#how_to'

  get 'robots.txt', to: 'pages#robots'

  root 'pages#home'

  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'
end
