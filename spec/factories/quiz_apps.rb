FactoryGirl.define do
  factory :quiz_app do
    platform nil
    app_id { Faker::Number.number(7) }
    app_secret { Faker::Lorem.characters(20) }
  end
end
