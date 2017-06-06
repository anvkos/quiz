require 'rails_helper'

RSpec.describe Quiz, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:ratings).dependent(:destroy) }
    it { should have_many(:quiz_apps).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :rules }
  end

  describe '#count_players' do
    it 'returns count players' do
      count_players = 3
      quiz = create(:quiz)
      create_list(:rating, count_players, quiz: quiz)
      expect(quiz.count_players).to eq count_players
    end
  end

  describe '#count_games' do
    it 'returns sum of users games' do
      count_players = 3
      count_games = 2
      quiz = create(:quiz)
      create_list(:rating, count_players, quiz: quiz, count_games: count_games)
      expect(quiz.count_games).to eq (count_players * count_games)
    end
  end
end
