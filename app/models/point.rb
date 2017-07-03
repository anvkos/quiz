class Point < ApplicationRecord
  belongs_to :quiz

  validates :time, :score, presence: true
end
