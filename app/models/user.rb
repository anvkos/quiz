class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :quizzes, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :games, dependent: :destroy

  validates :name, presence: true

  def author?(entity)
    id == entity.user_id
  end

  def place_in(quiz)
    max_score = ratings.find_by(quiz_id: quiz.id).try(:max_score)
    1 + Rating.where(quiz_id: quiz).where('max_score > :max_score', max_score: max_score).count
  end
end
