require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:quiz) { create(:quiz) }
  let(:question) { create(:question, quiz: quiz) }
  let!(:answer) { create(:answer, question: question) }

  describe 'PATCH #update' do
    context 'Authenticated user' do
      context 'author quiz' do
        before { sign_in quiz.user }

        context 'with valid attributes' do
          it 'assings the requested answer to @answer' do
            patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
            expect(assigns(:answer)).to eq answer
          end

          it 'changes answer attributes' do
            updated_body = 'new updated body'
            correct = true
            patch :update, params: { id: answer, answer: { body: updated_body, correct: true }, format: :js }
            answer.reload
            expect(answer.body).to eq updated_body
            expect(answer.correct).to be_truthy
          end

          it 'render update template' do
            patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          before do
            patch :update, params: { id: answer, answer: { body: nil }, format: :js }
          end

          it 'does not update the answer' do
            answer.reload
            expect(answer.body).not_to be_empty
          end

          it 'render update template' do
            expect(response).to render_template :update
          end
        end
      end

      context 'User is not the author' do
        let(:another_user) { create(:user) }
        let(:updated_body) { 'updated body' }

        before do
          sign_in another_user
          patch :update, params: { id: answer, answer: { body: updated_body }, format: :js }
        end

        it 'try update answer' do
          answer.reload
          expect(answer.body).to_not eq updated_body
        end

        it 'render forbidden template' do
          expect(response).to have_http_status(:forbidden)
          expect(response).to render_template 'errors/error_forbidden'
        end
      end
    end

    context 'Unauthorized user' do
      it 'try update answer' do
        updated_body = 'updated body'
        patch :update, params: { id: answer, answer: { body: updated_body }, format: :js }
        answer.reload
        expect(answer.body).to_not eq updated_body
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      context 'author quiz' do
        before { sign_in quiz.user }

        it 'delete answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
        end

        it 'render destroy template' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'User is not the author' do
        let(:another_user) { create(:user) }
        before { sign_in another_user }

        it 'delete try answer' do
          expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
        end

        it 'render forbidden template' do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to have_http_status(:forbidden)
          expect(response).to render_template 'errors/error_forbidden'
        end
      end
    end

    context 'Unauthorized user' do
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end
  end
end
