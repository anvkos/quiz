require 'rails_helper'

RSpec.describe QuestionsGame, type: :model do
  describe 'associations' do
    it { should belong_to(:game) }
    it { should belong_to(:question) }
  end
end
