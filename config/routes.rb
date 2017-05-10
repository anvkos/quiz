Rails.application.routes.draw do
  devise_for :users
  root 'quizzes#index'
  resources :quizzes do
    resources :questions, shallow: true do
      resources :answers, only: [:update, :destroy]
    end
  end
  resource :game do
    member do
      post :start
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
