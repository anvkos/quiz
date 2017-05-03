FactoryGirl.define do
  factory :question do
    body { Faker::Lorem.sentence }
    quiz

    trait :invalid do
      body nil
    end
  end
end

