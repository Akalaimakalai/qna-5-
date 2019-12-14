Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, except: %i[ index new ], shallow: true do
      post 'best', on: :member
    end
  end

  resources :files, only: %i[ destroy ]
  resources :links, only: %i[ destroy ]
  resources :medals, only: %i[ index ]

  resources :scores, only: [] do
    member do
      patch 'vote'
      put 'vote'
    end
  end
end
