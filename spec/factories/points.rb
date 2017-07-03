FactoryGirl.define do
  factory :point do
    quiz
    time 1
    score 10

    trait :invalid do
      quiz nil
      time nil
      score nil
    end
  end
end
