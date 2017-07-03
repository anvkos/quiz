class PointsController < ApplicationController
  before_action :set_quiz, only: :create

  authorize_resource

  respond_to :js

  def create
    authorize! :create, @quiz.points.new
    respond_with(@point = @quiz.points.create(point_params))
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def point_params
    params.require(:point).permit(:time, :score)
  end
end
