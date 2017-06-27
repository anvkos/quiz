class UsersController < ApplicationController
  before_action :authenticate_user!

  def ratings
    @games = current_user.games.training
    @ratings = current_user.ratings.includes(:quiz)
  end

  def quizzes
    @user_quizzes = current_user.quizzes
    @member_quizzes = current_user.member_quizzes
  end
end
