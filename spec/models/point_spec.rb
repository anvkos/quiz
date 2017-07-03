require 'rails_helper'

RSpec.describe Point, type: :model do
  describe 'associations' do
    it { should belong_to(:quiz) }
  end

  describe 'validations' do
    it { should validate_presence_of :time }
    it { should validate_presence_of :score }
  end
end
