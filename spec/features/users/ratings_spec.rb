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

  scenario 'sees his game result in the trining quiz' do
    quiz = create(:quiz, user: user, once_per: 1.hours)
    games = []
    1.upto(5) { |i| games << create(:game, quiz: quiz, user: user, created_at: i.hours.ago, score: i * 100) }
    sign_in(user)
    visit ratings_user_path
    5.times do |i|
      expect(page).to have_content games[i].quiz.title
      expect(page).to have_content games[i].created_at
      expect(page).to have_content games[i].score
    end
  end
end
