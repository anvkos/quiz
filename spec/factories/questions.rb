FactoryGirl.define do
  factory :question do
    body { Faker::Lorem.sentence }
    references quiz
  end
end
