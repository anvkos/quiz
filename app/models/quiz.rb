class Quiz < ApplicationRecord
  validates :title, :description, :rules, presence: true
end
