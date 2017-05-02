FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.sentence }
    references question
    correct false
  end
end
