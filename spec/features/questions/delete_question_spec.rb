require_relative '../feature_helper'

feature 'Delete question', %q{
  In order to remove the incorrect question
  As a user
  I want to be able to delete the question
} do
  given(:user) { create(:user) }
  given(:quiz) { create(:quiz, user: user) }
  given!(:question) { create(:question, quiz: quiz) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit edit_quiz_path(quiz)
    end

    scenario 'user try delete question', js: true do
      within '.question' do
        click_on 'Delete'
      end
      expect(page).to_not have_content question.body
      expect(page).to have_content 'Question was successfully destroyed.'
    end
  end
end
