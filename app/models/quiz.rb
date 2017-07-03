class Quiz < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :quiz_apps, dependent: :destroy
  has_many :points, dependent: :destroy

  validates :title, :description, :rules, presence: true

  def count_players
    ratings.count(:user_id)
  end

  def count_games
    ratings.sum(:count_games)
  end
end
