FactoryGirl.define do
  factory :authorization do
    user nil
    sequence(:provider) { |n| "Auth_provider_#{n}" }
    sequence(:uid) { |n| "uid_#{n}" }
  end
end
