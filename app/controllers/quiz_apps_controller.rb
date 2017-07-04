class QuizAppsController < ApplicationController
  before_action :authenticate_user!, except: :vkontakte
  before_action :set_quiz, only: [:create, :vkontakte]
  before_action :guest_authorization_vkontakte, only: :vkontakte
  before_action :set_quiz_app, only: [:update, :destroy]

  layout 'iframe'

  respond_to :js

  def create
    authorize! :create, @quiz.quiz_apps.new
    respond_with(@quiz_app = @quiz.quiz_apps.create(quiz_app_params))
  end

  def update
    authorize! :update, @quiz_app
    @quiz_app.update(quiz_app_params)
    respond_with(@quiz_app)
  end

  def destroy
    authorize! :destroy, @quiz_app
    @quiz_app.destroy
    respond_with(@quiz_app)
  end

  def vkontakte
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_quiz_app
    @quiz_app = QuizApp.find(params[:id])
  end

  def guest_authorization_vkontakte
    app = @quiz.quiz_apps.find_by!(platform: 'vkontakte')
    auth = VkontakteApi.auth(app.app_id, app.app_secret, vk_params[:auth_key], vk_params[:viewer_id])
    unless auth.nil?
      @user = User.find_for_oauth(auth, true)
      sign_in @user
    end
  end

  def quiz_app_params
    params.require(:quiz_app).permit(:platform, :app_id, :app_secret)
  end

  def vk_params
    params.permit(:auth_key, :viewer_id)
  end
end
