FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.sentence }
    question
    correct false
  end
end
