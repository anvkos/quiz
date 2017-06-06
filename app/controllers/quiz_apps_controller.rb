class QuizAppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz

  layout 'iframe'

  respond_to :js

  def create
    authorize! :create, @quiz.quiz_apps.new
    respond_with(@quiz_app = @quiz.quiz_apps.create(quiz_app_params))
  end

  def vkontakte
  end

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def quiz_app_params
    params.require(:quiz_app).permit(:platform, :app_id, :app_secret)
  end
end
