require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:quiz) }
  end

  describe '#first_max_score' do
    it 'beginning the maximum score' do
      ratings = create_list(:rating, 5, max_score: 3)
      third_rating = ratings.third
      third_rating.update(max_score: 10)
      fourth_rating = ratings.fourth
      fourth_rating.update(max_score: 7)
      expect(Rating.first_max_score.first).to eq third_rating
      expect(Rating.first_max_score.second).to eq fourth_rating
    end
  end
end
