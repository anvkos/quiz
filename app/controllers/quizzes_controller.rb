class QuizzesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :ratings]
  before_action :set_quiz, only: [:show, :edit, :update, :destroy, :ratings, :statistics]
  before_action :build_question, only: [:edit]

  authorize_resource
  skip_authorize_resource only: [:ratings, :statistics]

  respond_to :js, only: [:update]

  def index
    respond_with(@quizzes = Quiz.all)
  end

  def new
    respond_with(@quiz = Quiz.new)
  end

  def create
    @quiz = current_user.quizzes.create(quiz_params)
    respond_with(@quiz, location: -> { edit_quiz_path(@quiz) })
  end

  def show
    respond_with(@quiz)
  end

  def edit
    respond_with(@quiz)
  end

  def update
    @quiz.update(quiz_params)
    respond_with(@quiz)
  end

  def destroy
    @quiz.destroy
    respond_with(@quiz)
  end

  def ratings
    respond_with(@ratings = @quiz.ratings.includes(:user).first_max_score)
  end

  def statistics
  end

  private

  def quiz_params
    params.require(:quiz).permit(
      :title,
      :description,
      :rules,
      :starts_on,
      :ends_on,
      :once_per,
      :time_limit,
      :time_answer,
      :no_mistakes,
      :question_randomly
    )
  end

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def build_question
    @question = @quiz.questions.build
  end
end
