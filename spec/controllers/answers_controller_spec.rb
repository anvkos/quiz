require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:answer) { create(:answer) }

  describe 'PATCH #update' do
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

  describe 'DELETE #destroy' do
    it 'delete answer' do
      expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
    end

    it 'render destroy template' do
      delete :destroy, params: { id: answer }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
