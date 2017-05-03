require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:quiz) { create(:quiz) }

  describe 'POST #create' do
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
end
