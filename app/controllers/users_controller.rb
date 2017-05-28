class UsersController < ApplicationController
  before_action :authenticate_user!

  def ratings
    @games = current_user.games.training
    @ratings = current_user.ratings.includes(:quiz)
  end

  def quizzes
    @quizzes = current_user.quizzes
    @games = Game.for_quizzes(@quizzes)
  end
end
