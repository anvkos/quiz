FactoryGirl.define do
  factory :quiz do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    rules { Faker::Lorem.paragraph(5) }
    starts_on { Time.now }
    ends_on { Time.now }
    user

    trait :invalid do
      title nil
      description nil
      rules nil
    end
  end
end

