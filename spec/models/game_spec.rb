require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'associations' do
    it { should belong_to(:quiz) }
    it { should belong_to(:user) }
    it { should have_many(:questions_games) }
  end

  describe 'validations' do
    pending
  end

  describe '#choose_question' do
    pending
  end
end
