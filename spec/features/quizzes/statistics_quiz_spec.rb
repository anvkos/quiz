require_relative '../feature_helper.rb'

feature 'Statistics quiz', %q{
  In order see statistics game quiz
  As the author of the quiz
  I want to be able to it
} do
  given(:user) { create(:user) }
  given(:quiz) { create(:quiz, user: user) }

  before { sign_in(user) }

  describe 'Authenticated user' do
    context 'author' do
      before { sign_in(user) }
    end

    scenario 'User view counters' do
      count_players = 3
      count_games = 2
      1.upto(count_players) { create(:rating, quiz: quiz, count_games: count_games) }
      visit statistics_quiz_path(quiz)
      expect(page).to have_content quiz.title
      expect(page).to have_content count_players
      expect(page).to have_content count_players * count_games
    end

    scenario 'User view games' do
      games = create_list(:game, 10, quiz: quiz)
      visit statistics_quiz_path(quiz)
      games.each_with_index do |game|
        expect(page).to have_content game.user.name
        expect(page).to have_content game.created_at
        expect(page).to have_content game.score
      end
    end
  end
end
