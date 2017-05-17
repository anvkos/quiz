require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:quizzes).dependent(:destroy) }
    it { should have_many(:ratings).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe '#author?' do
    it 'returns true' do
      user_id = rand(1..100)
      user = create(:user, id: user_id)
      entity = double('Entity')
      allow(entity).to receive_messages(user_id: user_id)
      expect(user.author?(entity)).to be_truthy
    end

    it 'returns false' do
      user_id = rand(1..100)
      other_id = rand(200..300)
      user = create(:user, id: user_id)
      entity = double('Entity')
      allow(entity).to receive_messages(user_id: other_id)
      expect(user.author?(entity)).to be_falsey
    end
  end

  describe '#place_in' do
    let(:user) { create(:user) }
    let(:quiz) { create(:quiz) }

    it 'returns last place in quiz' do
      5.times do |i|
        create(:rating, quiz: quiz, max_score: i + 1)
      end
      create(:rating, quiz: quiz, user: user, max_score: 0)
      expect(user.place_in(quiz)).to eq 6
    end

    it 'returns first place in quiz' do
      5.times do |i|
        create(:rating, quiz: quiz, max_score: i + 1)
      end
      create(:rating, quiz: quiz, user: user, max_score: 5)
      expect(user.place_in(quiz)).to eq 1
    end

    it 'returns place in quiz' do
      ratings = []
      5.downto(1) do |i|
        ratings << create(:rating, quiz: quiz, max_score: i * 10)
      end
      place = rand(0..5)
      create(:rating, quiz: quiz, user: user, max_score: ratings[place].max_score + 1)
      expect(user.place_in(quiz)).to eq place + 1
    end
  end
end
