require 'rails_helper'

RSpec.describe PlayGameService do
  describe '#perform' do
    let!(:service) { PlayGameService.new }
    let(:user) { create(:user) }
    let(:quiz) { create(:quiz) }
    let(:game) { create(:game, quiz: quiz, user: user) }
    let(:question_one) { create(:question, quiz: quiz) }
    let!(:answer_question_one) { create(:answer, question: question_one) }

    before do
      game.questions_games.create(question: question_one)
    end

    it 'returns next question' do
      question_two = create(:question, quiz: quiz)
      expect(service.perform(answer_question_one, user)).to eq question_two
    end

    it 'score are increased by 1' do
      answer_question_one.correct = true
      answer_question_one.save
      score = game.score
      service.perform(answer_question_one, user)
      expect(game.reload.score).to eq (score + 1)
    end

    it 'score not increase increased' do
      score = game.score
      service.perform(answer_question_one, user)
      expect(game.reload.score).to eq score
    end

    it 'publishes :game_not_found' do
      other_user = create(:user)
      expect { service.perform(answer_question_one, other_user) }.to broadcast(:game_not_found)
    end

    context 'publishes :game_finished' do
      it 'game already finished' do
        game.finished = true
        game.save
        expect { service.perform(answer_question_one, user) }.to broadcast(:game_finished)
      end

      it 'no more questions' do
        expect { service.perform(answer_question_one, user) }.to broadcast(:game_finished)
      end
    end
  end
end