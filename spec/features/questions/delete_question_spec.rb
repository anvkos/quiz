require_relative '../feature_helper'

feature 'Delete question', %q{
  In order to remove the incorrect question
  As a user
  I want to be able to delete the question
} do
  given(:quiz) { create(:quiz) }
  given!(:question) { create(:question, quiz: quiz) }

  scenario 'user try delete question', js: true do
    visit quiz_path(quiz)
    within '.question' do
      click_on 'Delete'
    end
    expect(page).to_not have_content question.body
    expect(page).to have_content 'Question was successfully destroyed.'
  end
end
