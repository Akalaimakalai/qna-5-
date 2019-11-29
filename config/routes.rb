Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    delete 'destroy_file', on: :member

    resources :answers, except: %i[ index new ], shallow: true do
      post 'best', on: :member
      delete 'destroy_file', on: :member
    end
  end
end
