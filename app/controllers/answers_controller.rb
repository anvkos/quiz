class AnswersController < ApplicationController
  before_action :set_answer, only: [:update, :destroy]

  respond_to :js

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    @answer.destroy
    respond_with(@answer)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :correct)
  end
end
