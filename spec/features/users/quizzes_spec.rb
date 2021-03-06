require_relative '../feature_helper'

feature 'User quizzes', %q{
  In order see statistics on quizzes
  As author quizzes.
  I want to be able to see counts games and counts users for quizzes
} do
  given(:user) { create(:user) }
  given(:quizzes) { create_list(:quiz, 2, user: user) }

  scenario 'User see simple statistic created quizzes' do
    quizzes.each_with_index do |quiz, index|
      create_list(:rating, index + 2, quiz: quiz, count_games: index + 3)
    end
    sign_in(user)
    visit quizzes_user_path
    quizzes.each_with_index do |quiz, index|
      count_players = index + 2
      count_games = (index + 3) * count_players
      expect(page).to have_link quiz.title
      expect(page).to have_content count_players
      expect(page).to have_content count_games
    end
  end

  scenario 'User see links in which quizzes played' do
    ratings = create_list(:rating, 2, user: user)
    sign_in(user)
    visit quizzes_user_path
    ratings.each_with_index do |rating|
      expect(page).to have_link rating.quiz.title
    end
  end
end
