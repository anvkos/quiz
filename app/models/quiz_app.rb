class QuizApp < ApplicationRecord
  PLATFORMS = {
    vkontakte: 'vkontakte'
  }.freeze

  belongs_to :quiz

  validates :platform, :app_id, :app_secret, presence: true
end
