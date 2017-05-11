class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :quizzes, dependent: :destroy
  has_many :ratings, dependent: :destroy

  validates :name, presence: true

  def author?(entity)
    id == entity.user_id
  end
end
