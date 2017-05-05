require_relative '../feature_helper'

feature 'Delete quiz', %q{
  In order to delete wrong quiz
  As a user
  I want to be able to delete quiz
} do
  given(:quiz) { create(:quiz) }

  scenario 'User remove quiz' do
    visit quiz_path(quiz)
    within '.quiz' do
      click_on 'Delete'
    end
    expect(page).to have_content 'Quiz was successfully destroyed.'
    expect(page).to_not have_content quiz.title
    expect(page).to_not have_content quiz.description
    expect(page).to_not have_content quiz.rules
  end
end
