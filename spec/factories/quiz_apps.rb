FactoryGirl.define do
  factory :quiz_app do
    platform { Faker::Lorem.word }
    app_id { Faker::Number.number(7) }
    app_secret { Faker::Lorem.characters(20) }

    trait :invalid do
      platform nil
      app_id nil
      app_secret nil
    end
  end
end
