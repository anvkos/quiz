FactoryGirl.define do
  factory :quiz do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    rules { Faker::Lorem.paragraph(5) }
    starts_on { Time.now }
    ends_on { Time.now }
    user
    once_per 0
    time_limit 0
    time_answer 0
    no_mistakes false

    trait :invalid do
      title nil
      description nil
      rules nil
    end

    trait :with_questions do
      ignore do
        number_questions 5
      end

      after(:create) do |quiz, evaluator|
        create_list(:question, evaluator.number_questions, quiz: quiz)
      end
    end
  end
end
