require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:user) { create(:user) }
  let!(:quiz) { create(:quiz) }

  before { sign_in user }

  describe 'POST #start' do
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
      it 'quiz has no questions' do
        post :start, params: { quiz_id: quiz.id }, format: :json
        data = JSON.parse(response.body)
        expect(response).to have_http_status :bad_request
        expect(data['error']).to eq 'Error start game'
        expect(data['error_message']).to eq 'Quiz has no questions'
      end

      it 'user already play' do
        quiz = create(:quiz, :with_questions, once_per: 1.hours)
        create(:game, quiz: quiz, user: user)
        post :start, params: { quiz_id: quiz.id }, format: :json
        data = JSON.parse(response.body)
        expect(response).to have_http_status :forbidden
        expect(data['error']).to eq 'Error start game'
        expect(data['error_message']).to eq 'You play too often'
      end
    end
  end

  describe 'POST #check_answer' do
    let(:game) { create(:game, quiz: quiz, user: user) }

    context 'check answer' do
      let!(:questions) { create_list(:question, 2, quiz: quiz) }
      let!(:answer) { create(:answer, question: questions.first) }
      let!(:questions_game) { create(:questions_game, game: game, question: questions.first) }

      before do
        post :check_answer, params: { answer_id: answer.id }, format: :json
      end

      it 'returns 202 status' do
        expect(response).to have_http_status :accepted
      end

      it 'retuns question' do
        data = JSON.parse(response.body)
        expect(data['id']).to eq questions.last.id
        expect(data['body']).to eq questions.last.body
      end
    end

    context 'game not found' do
      let(:answer) { create(:answer) }

      before do
        post :check_answer, params: { answer_id: answer.id }, format: :json
      end

      it 'returns 404 status' do
        expect(response).to have_http_status :not_found
      end

      it 'returns error message' do
        data = JSON.parse(response.body)
        expect(data['error']).to eq 'Error game'
        expect(data['error_message']).to eq 'Game not found'
      end
    end

    context 'finish game' do
      let!(:question) { create(:question, quiz: quiz) }
      let!(:answer) { create(:answer, question: question) }
      let!(:questions_game) { create(:questions_game, game: game, question: question) }

      before do
        game.finished = true
        game.save
        post :check_answer, params: { answer_id: answer.id }, format: :json
      end

      it 'returns 200 status' do
        expect(response).to have_http_status :success
      end

      it 'returns score' do
        data = JSON.parse(response.body)
        expect(data['score']).to eq game.score
        expect(data['finished']).to eq game.finished
        expect(data['action']).to eq 'finish'
        expect(data['message']).to eq 'Game finished'
      end
    end
  end
end
