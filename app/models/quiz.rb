class Quiz < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :ratings, dependent: :destroy

  validates :title, :description, :rules, presence: true
end
