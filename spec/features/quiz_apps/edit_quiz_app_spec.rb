require_relative '../feature_helper'

feature 'Quiz app editing', %q{
  In order to fix mistake
  As  the author of the quiz
  I'd like ot be able to edit quiz app
} do
  given(:user) { create(:user) }
  given(:quiz) { create(:quiz, user: user) }
  given!(:quiz_app) { create(:quiz_app, quiz: quiz) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit edit_quiz_path(quiz)
    end

    describe 'User edit quiz app' do
      scenario 'sees link to Edit' do
        within '.quiz-app' do
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'try to edit quiz app', js: true do
        updated_app = {
          platform: 'updated platform',
          app_id: 789_789,
          app_secret: 'updated_app_secret'
        }
        within '.quiz-app' do
          click_on 'Edit'
          fill_in 'quiz_app[platform]', with: updated_app[:platform]
          fill_in 'quiz_app[app_id]', with: updated_app[:app_id]
          fill_in 'quiz_app[app_secret]', with: updated_app[:app_secret]
          click_on 'Save'
          expect(page).to_not have_content quiz_app.platform
          expect(page).to_not have_content quiz_app.app_id
          expect(page).to_not have_content quiz_app.app_secret
          expect(page).to have_content updated_app[:platform]
          expect(page).to have_content updated_app[:app_id]
          expect(page).to have_content updated_app[:app_secret]
          within '.quiz-app-edit' do
            expect(page).to_not have_selector 'input'
          end
        end
      end

      context 'try update to quiz app with invalid attributes' do
        scenario 'body text is blank', js: true do
          within ".quiz-app-#{quiz_app.id}" do
            click_on 'Edit'
            fill_in 'quiz_app[platform]', with: ''
            fill_in 'quiz_app[app_id]', with: ''
            fill_in 'quiz_app[app_secret]', with: ''
            click_on 'Save'
          end
          expect(page).to have_content "Platform can't be blank"
          expect(page).to have_content "App can't be blank"
          expect(page).to have_content "App secret can't be blank"
        end
      end
    end
  end
end
