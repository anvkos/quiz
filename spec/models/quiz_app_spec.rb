require 'rails_helper'

RSpec.describe QuizApp, type: :model do
  describe 'associations' do
    it { should belong_to(:quiz) }
  end

  describe 'validations' do
    it { should validate_presence_of :platform }
    it { should validate_presence_of :app_id }
    it { should validate_presence_of :app_secret }
  end
end
