Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, except: %i[ index new ], shallow: true
  end

  resources :answers do
    post 'best', on: :member
  end
end
