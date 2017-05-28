require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'associations' do
    it { should belong_to(:quiz) }
    it { should belong_to(:user) }
    it { should have_many(:questions_games) }
  end

  describe '.training' do
    let(:quiz) { create(:quiz, once_per: 10) }

    it 'returns games quiz with once_per' do
      games = create_list(:game, 5, quiz: quiz)
      other_games = create_list(:game, 5)
      training_games = Game.training
      expect(training_games).to match_array(games)
      expect(training_games).not_to match_array(other_games)
    end

    it 'order by asc created_at game' do
      games = create_list(:game, 5, quiz: quiz)
      first = games[3]
      second = games[4]
      first.update(created_at: 2.hours.ago)
      second.update(created_at: 1.hours.ago)
      training_games = Game.training
      expect(training_games.first).to eq first
      expect(training_games.second).to eq second
    end
  end

  describe '.for_quizzes' do
    it 'returns game present quizzes' do
      quizzes = create_list(:quiz, 5)
      games_all = []
      quizzes.each { |quiz| games_all << create(:game, quiz: quiz) }
      expected_games = [games_all.first, games_all.last]
      other_games = games_all - expected_games
      games = Game.for_quizzes([quizzes.last, quizzes.first])
      games.each do |game|
        expect(games).to match_array(expected_games)
        expect(games).not_to match_array(other_games)
      end
    end
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
