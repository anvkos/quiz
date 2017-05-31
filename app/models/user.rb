class User < ApplicationRecord
  TEMPORARY_EMAIL_PREFIX = 'temporary@email'.freeze
  TEMPORARY_EMAIL_REGEX = /\Atemporary@email/
  TEMPORARY_NAME = 'user_temporary'.freeze

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:facebook, :vkontakte]

  has_many :quizzes, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :games, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  validates :name, presence: true

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email] if auth.info && auth.info[:email]
    email ||= "#{TEMPORARY_EMAIL_PREFIX}-#{auth.provider}-#{auth.uid}.com"

    user = User.where(email: email).first
    unless user
      username = "#{TEMPORARY_NAME}-#{auth.provider}-#{auth.uid}"
      password = Devise.friendly_token[0, 20]
      user = User.new(name: username, email: email, password: password, password_confirmation: password)
      user.skip_confirmation_notification! if user.email_temporary?
      user.save!
    end
    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def email_temporary?
    email && email =~ TEMPORARY_EMAIL_REGEX
  end

  def author?(entity)
    id == entity.user_id
  end

  def place_in(quiz)
    max_score = ratings.find_by(quiz_id: quiz.id).try(:max_score)
    1 + Rating.where(quiz_id: quiz).where('max_score > :max_score', max_score: max_score).count
  end
end
