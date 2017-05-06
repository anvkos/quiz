Rails.application.routes.draw do
  root 'quiz#index'
  resources :quizzes do
    resources :questions, shallow: true do
    end
  end
  resources :answers, only: [:update, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
