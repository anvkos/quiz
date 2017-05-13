require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'associations' do
    it { should belong_to(:quiz) }
    it { should belong_to(:user) }
    it { should have_many(:questions_games) }
  end

  describe '#choose_question' do
    let(:quiz) { create(:quiz) }
    let(:game) { create(:game, quiz: quiz) }
    let(:questions) { create_list(:question, 2, quiz: quiz) }

    it 'returns question that have not been selected before' do
      game.questions_games.create(question: questions.first)
      expect(game.choose_question).to eq questions.second
    end
  end
end
