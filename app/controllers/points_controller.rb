class PointsController < ApplicationController
  before_action :set_quiz, only: :create
  before_action :set_point, only: [:update]

  authorize_resource

  respond_to :js

  def create
    authorize! :create, @quiz.points.new
    respond_with(@point = @quiz.points.create(point_params))
  end

  def update
    authorize! :update, @point
    @point.update(point_params)
    respond_with(@point)
  end

  private

  def point_params
    params.require(:point).permit(:time, :score)
  end

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_point
    @point = Point.find(params[:id])
  end
end
