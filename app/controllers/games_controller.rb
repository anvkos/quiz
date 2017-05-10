class GamesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  before_action :authenticate_user!
  before_action :set_quiz, only: [:start]

  def start
    service = StartGameService.new
    service.on(:no_questions_quiz) { render_error(:bad_request, 'Error start quiz', "Quiz has no questions") }
    question = service.perform(@quiz, current_user)
    render json: question, status: :created unless question.nil?
  end

  private

  def game_params
    params.permit(:quiz_id, :answer_id)
  end

  def set_quiz
    @quiz = Quiz.find(game_params[:quiz_id])
  end

  def render_not_found(error)
    render_error(:not_found, 'Error start quiz', error.message)
  end

  def render_error(status, error = 'error', message = 'message')
    render json: { error: error, error_message: message }, status: status
  end
end
