require 'rails_helper'

RSpec.describe StartGameService do
  describe '#perform' do
    let(:service) { StartGameService.new }
    let!(:user) { create(:user) }
    let(:quiz) { create(:quiz) }
    let!(:question) { create(:question, quiz: quiz) }

    it 'create new game' do
      expect{ service.perform(quiz, user) }.to change(Game, :count).by(1)
    end

    it 'returns question' do
      expect(service.perform(quiz, user)).to eq question
    end

    it 'create new record questions game' do
      expect{ service.perform(quiz, user) }.to change(QuestionsGame, :count).by(1)
    end

    it 'publishes :no_questions_quiz' do
      quiz_without_question = create(:quiz)
      expect{ service.perform(quiz_without_question, user) }.to broadcast(:no_questions_quiz)
    end

    it 'user rating increases the count of games' do
      rating = create(:rating, user: user, quiz: quiz)
      service.perform(quiz, user)
      expect(rating.reload.count_games).to eq 1
    end
  end
end
