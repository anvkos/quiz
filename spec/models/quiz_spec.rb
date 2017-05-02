require 'rails_helper'

RSpec.describe Quiz, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :rules }
  end
end
