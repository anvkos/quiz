FactoryGirl.define do
  factory :user do
    name { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password { '123456' }
    password_confirmation { '123456' }
  end
end
