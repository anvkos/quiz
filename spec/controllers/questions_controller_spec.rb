require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:quiz) { create(:quiz) }

  describe 'POST #create' do
    context 'Authenticated user' do
      context 'author quiz' do
        before { sign_in quiz.user }

        context 'with valid attributes' do
          it 'saves the new question in the database' do
            expect do
              post :create, params: { quiz_id: quiz, question: attributes_for(:question), format: :js }
            end.to change(quiz.questions, :count).by(1)
          end

          it 'render create template' do
            post :create, params: { quiz_id: quiz, question: attributes_for(:question), format: :js }
            expect(response).to render_template :create
          end
        end

        context 'with invalid attributes' do
          it 'does not save the question' do
            expect do
              post :create, params: { quiz_id: quiz, question: attributes_for(:question, :invalid), format: :js }
            end.to_not change(Question, :count)
          end

          it 'render create template' do
            post :create, params: { quiz_id: quiz, question: attributes_for(:question, :invalid), format: :js }
            expect(response).to render_template :create
          end
        end
      end

      context 'User is not author quiz' do
        let(:another_user) { create(:user) }

        before { sign_in another_user }

        it 'Not saved the new question in the database' do
          expect do
              post :create, params: { quiz_id: quiz, question: attributes_for(:question), format: :js }
            end.to_not change(Question, :count)
        end

        it 'render forbidden template' do
          post :create, params: { quiz_id: quiz, question: attributes_for(:question), format: :js }
          expect(response).to have_http_status(:forbidden)
          expect(response).to render_template 'errors/error_forbidden'
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question) { create(:question, quiz: quiz) }

    context 'Authenticated user' do
      context 'author quiz' do
        before { sign_in quiz.user }

        context 'with valid attributes' do
          it 'assings the requested question to @question' do
            patch :update, params: { id: question, question: attributes_for(:question), format: :js }
            expect(assigns(:question)).to eq question
          end

          it 'changes question attributes' do
            updated_body = 'new updated body'
            patch :update, params: { id: question, question: { body: updated_body }, format: :js }
            question.reload
            expect(question.body).to eq updated_body
          end

          it 'render update template' do
            patch :update, params: { id: question, question: attributes_for(:question), format: :js }
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          before do
            patch :update, params: { id: question, question: { body: nil }, format: :js }
          end

          it 'does not update the question' do
            question.reload
            expect(question.body).not_to be_empty
          end

          it 'render update template' do
            expect(response).to render_template :update
          end
        end
      end

      context 'User is not author' do
        let(:another_user) { create(:user) }
        let(:updated_body) { 'updated body' }

        before do
          sign_in another_user
          patch :update, params: { id: question, question: { body: updated_body }, format: :js }
        end

        it 'try update question' do
          question.reload
          expect(question.body).to_not eq updated_body
        end

        it 'render forbidden template' do
          expect(response).to have_http_status(:forbidden)
          expect(response).to render_template 'errors/error_forbidden'
        end
      end
    end

    context 'Unauthorized user' do
      it 'try update question' do
        updated_body = 'updated body'
        patch :update, params: { id: question, question: { body: updated_body }, format: :js }
        question.reload
        expect(question.body).to_not eq updated_body
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, quiz: quiz) }

    context 'Authenticated user' do
      context 'author quiz' do
        before { sign_in quiz.user }

        it 'delete question' do
          expect { delete :destroy, params: { id: question }, format: :js }.to change(Question, :count).by(-1)
        end

        it 'render destroy template' do
          delete :destroy, params: { id: question }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'User is not the author' do
        let(:another_user) { create(:user) }
        before { sign_in another_user }

        it 'delete try question' do
          expect { delete :destroy, params: { id: question }, format: :js }.to_not change(Question, :count)
        end

        it 'render forbidden template' do
          delete :destroy, params: { id: question }, format: :js
          expect(response).to have_http_status(:forbidden)
          expect(response).to render_template 'errors/error_forbidden'
        end
      end
    end

    context 'Unauthorized user' do
      it 'delete question' do
        expect { delete :destroy, params: { id: question }, format: :js }.to_not change(Question, :count)
      end
    end
  end
end
