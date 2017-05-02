class QuizzesController < ApplicationController
  before_action :set_quiz, only: [:show]
  before_action :build_question, only: [:show]

  def new
    respond_with(@quiz = Quiz.new)
  end

  def create
    respond_with(@quiz = Quiz.create(quiz_params))
  end

  def show
    respond_with(@quiz)
  end

  private

  def quiz_params
    params.require(:quiz).permit(:title, :description, :rules, :starts_on, :ends_on)
  end

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def build_question
    @question = @quiz.questions.build
  end
end
