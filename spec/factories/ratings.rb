FactoryGirl.define do
  factory :rating do
    user
    quiz
    count_games 0
    max_score 0
  end
end
