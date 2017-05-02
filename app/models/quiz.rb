class Quiz < ApplicationRecord
  has_many :questions, dependent: :destroy

  validates :title, :description, :rules, presence: true
end
