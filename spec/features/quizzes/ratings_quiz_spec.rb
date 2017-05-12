require_relative '../feature_helper.rb'

feature 'Ratings quiz', %q{
  In order see the maximum score of participants
  As a user
  I want to be able to it
} do
  given(:quiz) { create(:quiz) }

  scenario 'User view max score users' do
    ratings = create_list(:rating, 10, quiz: quiz, max_score: 5)
    visit ratings_quiz_path(quiz)
    expect(page).to have_content quiz.title
    ratings.each do |rating|
      expect(page).to have_content rating.user.name
      expect(page).to have_content rating.max_score
    end
  end
end
