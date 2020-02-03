require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper

  concern :commentable do
    resources :comments, shallow: true, only: %i[ create destroy ]
  end

  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  resources :questions, concerns: %i[ commentable ] do
    resources :answers, except: %i[ index new ], shallow: true, concerns: %i[ commentable ] do
      post 'best', on: :member
    end

    resources :subscriptions, only: %i[ create destroy ], shallow: true
  end

  resources :files, only: %i[ destroy ]
  resources :links, only: %i[ destroy ]
  resources :medals, only: %i[ index ]
  resources :votes, only: %i[ create ]
  get '/search', to: 'search#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[ index ] do
        get :me, on: :collection
      end

      resources :questions, only: %i[ index show create update destroy ] do
        resources :answers, only: %i[ index show create update destroy ], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
