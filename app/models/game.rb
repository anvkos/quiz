class Game < ApplicationRecord
  belongs_to :quiz
  belongs_to :user
  has_many :questions_games
  has_many :questions, through: :questions_games

  def choose_question
    unanswered_questions = quiz.questions.where.not(id: questions)
    unanswered_questions.sample
  end
end
