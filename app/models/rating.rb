class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :quiz

  paginates_per 20

  scope :first_max_score, -> { order('max_score DESC') }
end
