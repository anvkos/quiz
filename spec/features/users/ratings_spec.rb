require_relative '../feature_helper'

feature 'User ratings', %q{
  in order to see place, max score in quiz.
  As authenticated user.
  I want to be able see my max score in quizTo conduct a quiz
} do
  given(:user) { create(:user) }

  scenario 'User see max score in quizzes' do
    ratings = []
    5.times { ratings << create(:rating, user: user, max_score: rand(1..100)) }
    sign_in(user)
    visit ratings_user_path
    5.times do |i|
      expect(page).to have_content ratings[i].quiz.title
      expect(page).to have_content ratings[i].max_score
    end
  end
end
