Rails.application.routes.draw do

  root 'quizzes#index'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  patch 'confirmations/email', to: 'confirmations#email', as: :confirmation_email
  get 'users/ratings', to: 'users#ratings', as: 'ratings_user'
  get 'users/quizzes', to: 'users#quizzes', as: 'quizzes_user'

  resources :quizzes do
    resources :questions, shallow: true do
      resources :answers, only: [:update, :destroy]
    end
    get :ratings, on: :member
  end
  resource :game do
    member do
      post :start
      post :check_answer
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
