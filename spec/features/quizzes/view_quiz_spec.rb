require_relative '../feature_helper'

feature 'View quiz', %q{
  In order to read the text of the quiz
  As a user
  I want to be able to see the issue
} do
  given(:quiz) { create(:quiz) }

  scenario 'User view quiz' do
    visit quiz_path(quiz)
    expect(page).to have_content quiz.title
    expect(page).to have_content quiz.description
    expect(page).to have_content quiz.rules
  end
end
