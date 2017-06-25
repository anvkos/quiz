require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should belong_to(:quiz) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should accept_nested_attributes_for :answers }
  end

  describe 'validations' do
    it { should validate_presence_of :body }

    describe '#must_be_correct_answer' do
      context 'there is no correct answer' do
        before do
          @question = build(:question)
          @question.answers << build(:answer, question: @question, correct: false)
        end

        it 'validate false' do
          expect(@question.valid?).to eq false
        end

        it 'question error - no answer is correct' do
          @question.valid?
          expect(@question.errors[:base]).to  include('No answer is correct')
        end
      end

      context 'correct answer exists' do
        it 'validate true' do
          question = build(:question)
          question.answers << build(:answer, question: question, correct: true)
          expect(question.valid?).to eq true
        end
      end
    end
  end
end
