class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, Quiz
    can [:edit, :update, :destroy], Quiz, user_id: user.id
    can [:create, :update, :destroy], Question do |question|
      user.author?(question.quiz)
    end
    can [:create, :update, :destroy], Answer do |answer|
      user.author?(answer.question.quiz)
    end
    can [:create, :update], QuizApp do |quiz_app|
      user.author?(quiz_app.quiz)
    end
  end
end
