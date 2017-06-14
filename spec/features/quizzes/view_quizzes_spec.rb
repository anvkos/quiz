require_relative '../feature_helper'

feature 'View quizzes', %q{
  In order to play the quizzes
  As a user
  I want to be able to see list quizzes
} do
  scenario 'User view quizzes' do
    quizzes = create_list(:quiz, 5)
    visit quizzes_path
    quizzes.each do |quiz|
      expect(page).to have_content quiz.title
      expect(page).to have_content quiz.description
      expect(page).to have_content quiz.description
      expect(page).to have_link('Play', href: quiz_path(quiz))
    end
  end
end
