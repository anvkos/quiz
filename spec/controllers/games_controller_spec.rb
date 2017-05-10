require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:user) { create(:user) }
  let!(:quiz) { create(:quiz) }

  describe 'POST #start' do
    before { sign_in user }

    context 'start game' do
      let!(:question) { create(:question, quiz: quiz) }

      before { post :start, params: { quiz_id: quiz.id }, format: :json }

      it 'returns 201 status' do
        expect(response).to have_http_status :created
      end

      it 'retuns question' do
        data = JSON.parse(response.body)
        expect(data['id']).to eq question.id
        expect(data['body']).to eq question.body
      end
    end

    context 'returns start game error' do
      it 'quiz not found' do
        post :start, params: { quiz_id: 666 }, format: :json
        data = JSON.parse(response.body)
        expect(response).to have_http_status :not_found
        expect(data['error']).to eq 'Error start quiz'
        expect(data['error_message']).to match "Couldn't find Quiz with"
      end

      it 'quiz has no questions' do
        post :start, params: { quiz_id: quiz.id }, format: :json
        data = JSON.parse(response.body)
        expect(response).to have_http_status :bad_request
        expect(data['error']).to eq 'Error start quiz'
        expect(data['error_message']).to eq 'Quiz has no questions'
      end
    end
  end
end
