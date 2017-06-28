class UsersController < ApplicationController
  before_action :authenticate_user!

  def quizzes
    @user_quizzes = current_user.quizzes
    @member_quizzes = current_user.member_quizzes
  end
end
