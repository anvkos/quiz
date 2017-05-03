require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should belong_to(:quiz) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should accept_nested_attributes_for :answers }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end
end
