class UsersController < ApplicationController
  before_action :authenticate_user!

  def ratings
    respond_with(@ratings = current_user.ratings.includes(:quiz))
  end

  def quizzes
    respond_with(@quizzes = current_user.quizzes)
  end
end
