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

    it 'no question' do
      expect(game.choose_question).to be_nil
    end

    it 'question ended' do
      questions = create_list(:question, 2, quiz: quiz)
      questions.each do |question|
        game.questions_games.create(question: question)
      end
      expect(game.choose_question).to be_nil
    end

    it 'returns question quiz' do
      question = create(:question, quiz: quiz)
      expect(game.choose_question).to eq(question)
    end

    it 'returns question that have not been selected before' do
      questions = create_list(:question, 50, quiz: quiz)
      previously_selected = []
      questions.count.times do
        question = game.choose_question
        expect(previously_selected).not_to include(question)
        game.questions_games.create(question: question)
        previously_selected << question
      end
    end

    it 'returns different lines at different times' do
      create_list(:question, 50, quiz: quiz)
      10.times do
        one_choose = game.choose_question
        two_choose = game.choose_question
        expect(one_choose).not_to eq two_choose
      end
    end
  end
end
