require_relative '../feature_helper'

feature 'Delete quiz app', %q{
  In order to remove the incorrect quiz app
  As the author of the quiz
  I want to be able to delete the quiz app
} do
    given(:user) { create(:user) }
  given(:quiz) { create(:quiz, user: user) }
  given!(:quiz_app) { create(:quiz_app, quiz: quiz) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit edit_quiz_path(quiz)
    end

    scenario 'sees link to Delete' do
      within '.quiz-app' do
        expect(page).to have_link 'Delete'
      end
    end

    scenario 'user try delete quiz app', js: true do
      within '.quiz-app' do
        click_on 'Delete'
      end
      expect(page).to_not have_content quiz_app.platform
      expect(page).to_not have_content quiz_app.app_id
      expect(page).to_not have_content quiz_app.app_secret
      expect(page).to have_content 'Quiz App was successfully destroyed.'
    end
  end
end
