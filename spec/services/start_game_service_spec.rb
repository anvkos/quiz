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

    it 'return nil - question not found' do
      quiz_without_question = create(:quiz)
      expect(service.perform(quiz_without_question, user)).to be_nil
    end

    it 'user rating increases the count of games'

  end
end
