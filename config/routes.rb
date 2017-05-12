Rails.application.routes.draw do

  root 'quizzes#index'
  devise_for :users
  get 'users/ratings', to: 'users#ratings', as: 'user_ratings'

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
