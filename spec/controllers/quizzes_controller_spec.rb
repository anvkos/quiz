require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  describe "GET #new" do
    sign_in_user
    before { get :new }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new Quiz to @quiz' do
      expect(assigns(:quiz)).to be_a_new(Quiz)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context 'Authenticated user' do
      sign_in_user

      context 'with valid attributes' do
        it 'saves the new quiz in the database' do
          expect do
            post :create, params: { quiz: attributes_for(:quiz) }
          end.to change(Quiz, :count).by(1)
        end

        it 'quiz belongs to the user' do
          post :create, params: { quiz: attributes_for(:quiz) }
          expect(Quiz.last.user).to eq @user
        end

        it 'redirects to edit quiz' do
          post :create, params: { quiz: attributes_for(:quiz) }
          expect(response).to redirect_to edit_quiz_path(assigns(:quiz))
        end
      end

      context 'with invalid attributes' do
        it 'does not save the quiz' do
          expect do
            post :create, params: { quiz: attributes_for(:quiz, :invalid) }
          end.to_not change(Quiz, :count)
        end

        it 're-rendes new view' do
          post :create, params: { quiz: attributes_for(:quiz, :invalid) }
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'GET #show' do
    let(:quiz) { create(:quiz) }
    before { get :show, params: { id: quiz } }

    it 'assings the requested quiz to @quiz' do
      expect(assigns(:quiz)).to eq quiz
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #edit' do
    let(:quiz) { create(:quiz) }

    context 'Authenticated user' do
      context 'author' do
        before do
         sign_in quiz.user
         get :edit, params: { id: quiz }
       end

        it 'assings the requested quiz to @quiz' do
          expect(assigns(:quiz)).to eq quiz
        end

        it 'renders edit view' do
          expect(response).to render_template :edit
        end
      end

      context 'not author' do
        sign_in_user
        it 'try edit quiz' do
          get :edit, params: { id: quiz }
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'Non-authenticated user' do
      it 'try edit quiz' do
        get :edit, params: { id: quiz }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    let(:quiz) { create(:quiz) }

    context 'Authenticated user' do
      context 'author' do
        before { sign_in quiz.user }

        context 'valid attributes' do
          it 'assigns the requested quiz to @quiz' do
            patch :update, params: { id: quiz, quiz: attributes_for(:quiz), format: :js }
            expect(assigns(:quiz)).to eq quiz
          end

          it 'change quiz attributes' do
            updated = {
              title: 'updated title',
              description: 'updated description',
              rules: 'updated rules',
              starts_on: Time.zone.now + 1.hours,
              ends_on: Time.zone.now + 1.day,
              once_per: 1.days.to_i,
              time_limit: 15.minutes.to_i,
              time_answer: 15,
              no_mistakes: true,
              question_randomly: true
            }
            patch :update, params: { id: quiz, quiz: updated, format: :js }
            quiz.reload
            expect(quiz.starts_on).to eq updated[:starts_on].to_s
            expect(quiz.ends_on).to eq updated[:ends_on].to_s
            updated.except(:starts_on, :ends_on).each do |attr, value|
              expect(quiz.send(attr)).to eq value
            end
          end

          it 'render update template' do
            patch :update, params: { id: quiz, quiz: attributes_for(:quiz), format: :js }
            expect(response).to render_template :update
          end
        end

        context 'invalid attributes' do
          let(:expetced_data) { { title: "premier Title", description: 'premier description', rules: 'premier' } }
          let(:quiz) { create(:quiz, expetced_data) }

          before do
            patch :update, params: { id: quiz, quiz: { title: 'updated title', description: nil }, format: :js }
          end

          it 'does not update quiz' do
            quiz.reload
            expetced_data.each do |attr, value|
              expect(quiz.send(attr)).to eq value
            end
          end

          it 'render update template' do
            expect(response).to render_template :update
          end
        end

        context 'not author' do
          let(:updated_quiz) do
            {
              title: 'updated title',
              description: 'updated description',
              rules: 'updated rules'
            }
          end
          sign_in_user

          it 'try update question' do
            patch :update, params: { id: quiz, quiz: updated_quiz, format: :js }
            quiz.reload
            updated_quiz.each do |attr, value|
              expect(quiz.send(attr)).to_not eq value
            end
          end

          it 'render update template' do
            patch :update, params: { id: quiz, quiz: updated_quiz, format: :js }
            expect(response).to have_http_status(:forbidden)
            expect(response).to render_template 'errors/error_forbidden'
          end
        end
      end
    end

    context 'Unauthorized user' do
      it 'try update quiz' do
        updated_quiz = {
          title: 'updated title',
          description: 'updated description',
          rules: 'updated rules'
        }
        patch :update, params: { id: quiz, quiz: updated_quiz, format: :js }
        quiz.reload
        updated_quiz.each do |attr, value|
          expect(quiz.send(attr)).to_not eq value
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:quiz) { create(:quiz) }

    context 'Authenticated user' do
      context 'author' do
        before { sign_in quiz.user }

        it 'delete quiz' do
          expect { delete :destroy, params: { id: quiz } }.to change(Quiz, :count).by(-1)
        end

        it 'redirect to index view' do
          delete :destroy, params: { id: quiz }
          expect(response).to redirect_to quizzes_path
        end
      end

      context 'not author' do
        sign_in_user

        it 'delete quiz' do
          expect { delete :destroy, params: { id: quiz } }.to_not change(Quiz, :count)
        end

        it 'render destroy template' do
          delete :destroy, params: { id: quiz }, format: :js
          expect(response).to have_http_status(:forbidden)
          expect(response).to render_template 'errors/error_forbidden'
        end
      end
    end

    context 'Unauthorized user' do
      it 'delete quiz' do
        expect { delete :destroy, params: { id: quiz } }.to_not change(Quiz, :count)
      end
    end
  end

  describe 'GET #ratings' do
    let(:quiz) { create(:quiz) }
    it "returns http success" do
      get :ratings, params: { id: quiz }
      expect(response).to have_http_status(:success)
    end

    it 'render update template' do
      get :ratings, params: { id: quiz }
      expect(response).to render_template :ratings
    end
  end
end
