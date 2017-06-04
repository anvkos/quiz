class WidgetsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_quiz

  layout 'iframe'

  # authorize_resource

  def vkontakte
  end

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end
