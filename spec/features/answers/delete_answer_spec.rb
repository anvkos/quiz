require_relative '../feature_helper'

feature 'Delete answer', %q{
  In order to remove the incorrect answer
  As a user
  I want to be able to delete the answer
} do
  given(:quiz) { create(:quiz) }
  given(:question) { create(:question, quiz: quiz) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'user try delete answer', js: true do
    visit quiz_path(quiz)
    within '.answer' do
      click_on 'Delete'
    end
    expect(page).to_not have_content answer.body
    expect(page).to have_content 'Answer was successfully destroyed.'
  end
end
