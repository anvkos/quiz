class Game < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  has_many :questions_games
  has_many :questions, through: :questions_games

  paginates_per 25

  scope :training, -> { joins(:quiz).where('quizzes.once_per > 0').order(:created_at) }
  scope :for_quizzes, ->(_quizzes) { joins(:quiz).where(quiz: _quizzes) }

  def choose_question
    unanswered_questions = quiz.questions.where.not(id: questions)
    return unanswered_questions.first unless quiz.question_randomly
    unanswered_questions.shuffle.sample
  end

  def next_question
    quiz.questions.where.not(id: questions).first
  end
end
