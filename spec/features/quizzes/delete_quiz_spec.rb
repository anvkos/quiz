require_relative '../feature_helper'

feature 'Delete quiz', %q{
  In order to delete wrong quiz
  As the author of the quiz
  I want to be able to delete quiz
} do
  given(:user) { create(:user) }
  given(:quiz) { create(:quiz, user: user) }

  scenario 'Authenticated user remove quiz' do
    sign_in(user)
    visit edit_quiz_path(quiz)
    within '.quiz' do
      click_on 'Delete'
    end
    expect(page).to have_content 'Quiz was successfully destroyed.'
    expect(page).to_not have_content quiz.title
    expect(page).to_not have_content quiz.description
    expect(page).to_not have_content quiz.rules
  end
end
