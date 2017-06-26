class Question < ApplicationRecord
  belongs_to :quiz
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true
  validate :must_be_correct_answer

  private

  def must_be_correct_answer
    errors.add(:base, 'No answer is correct') unless answers.empty? || answers.map(&:correct).include?(true)
  end
end
