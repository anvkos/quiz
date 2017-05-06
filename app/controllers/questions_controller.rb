class QuestionsController < ApplicationController
  before_action :set_quiz, only: [:create]
  before_action :set_question, only: [:update, :destroy]

  authorize_resource

  respond_to :js

  def create
    authorize! :create, @quiz.questions.new
    respond_with(@question = @quiz.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    @question.destroy
    respond_with(@question)
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:body, answers_attributes: [:body, :correct])
  end
end
