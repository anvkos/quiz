class GamesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  before_action :authenticate_user!
  before_action :set_quiz, only: [:start]
  before_action :set_answer, only: [:check_answer]

  def start
    service = StartGameService.new
    service.on(:no_questions_quiz) { render_error(:bad_request, 'Error start game', "Quiz has no questions") }
    question = service.perform(@quiz, current_user)
    render json: question, status: :created unless question.nil?
  end

  def check_answer
    service = PlayGameService.new
    service.on(:game_not_found) { render_error(:not_found, 'Error game', "Game not found") }
    service.on(:game_finished) { |game| finish_game(game) }
    question = service.perform(@answer, current_user)
    render json: question, status: :accepted unless question.nil?
  end

  private

  def game_params
    params.permit(:quiz_id, :answer_id)
  end

  def set_quiz
    @quiz = Quiz.find(game_params[:quiz_id])
  end

  def set_answer
    @answer = Answer.find(game_params[:answer_id])
  end

  def finish_game(game)
    data = ActiveModelSerializers::SerializableResource.new(game).as_json
    render_success(data, 'finish', 'Game finished')
  end

  def render_not_found(error)
    render_error(:not_found, 'Error game', error.message)
  end

  def render_error(status, error = 'error', message = 'message')
    render json: { error: error, error_message: message }, status: status
  end

  def render_success(data, action, message)
    render json: data.merge(action: action, message: message)
  end
end