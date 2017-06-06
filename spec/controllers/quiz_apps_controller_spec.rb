require 'rails_helper'

RSpec.describe QuizAppsController, type: :controller do
  describe 'POST #create' do
    context 'Authenticated user' do
      let(:quiz) { create(:quiz) }

      context 'author quiz' do

        before { sign_in quiz.user }

        context 'with valid attributes' do
          it 'saves the new quiz_app in the database' do
            expect do
              post :create, params: { quiz_id: quiz, quiz_app: attributes_for(:quiz_app), format: :js }
            end.to change(quiz.quiz_apps, :count).by(1)
          end

          it 'render create template' do
            post :create, params: { quiz_id: quiz, quiz_app: attributes_for(:quiz_app), format: :js }
            expect(response).to render_template :create
          end
        end

        context 'with invalid attributes' do
          it 'does not save the quiz_app' do
            expect do
              post :create, params: { quiz_id: quiz, quiz_app: attributes_for(:quiz_app, :invalid), format: :js }
            end.to_not change(QuizApp, :count)
          end

          it 'render create template' do
            post :create, params: { quiz_id: quiz, quiz_app: attributes_for(:quiz_app, :invalid), format: :js }
            expect(response).to render_template :create
          end
        end
      end

      context 'User is not author quiz' do
        let(:another_user) { create(:user) }

        before { sign_in another_user }

        it 'Not saved the new quiz_app in the database' do
          expect do
              post :create, params: { quiz_id: quiz, quiz_app: attributes_for(:quiz_app), format: :js }
            end.to_not change(Question, :count)
        end

        it 'render forbidden template' do
          post :create, params: { quiz_id: quiz, quiz_app: attributes_for(:quiz_app), format: :js }
          expect(response).to have_http_status(:forbidden)
          expect(response).to render_template 'errors/error_forbidden'
        end
      end
    end
  end
end
