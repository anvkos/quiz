FactoryGirl.define do
  factory :game do
    quiz
    user
    score 0
    finished false

    trait :finished do
      finished false
    end
  end
end
