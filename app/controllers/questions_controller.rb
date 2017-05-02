class QuestionsController < ApplicationController
  before_action :set_quiz, only: [:create]

  respond_to :js

  def create
    respond_with(@question = @quiz.questions.create(question_params))
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def question_params
    params.require(:question).permit(:body, answers_attributes: [:body, :correct])
  end
end
