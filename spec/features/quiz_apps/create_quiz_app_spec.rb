require_relative '../feature_helper'

feature 'Create quiz app', %q{
  In order for participants to participate in a social network
  As the author of the quiz
  I want to add an app for social networking
} do
  given(:user) { create(:user) }
  given(:quiz) { create(:quiz, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit edit_quiz_path(quiz)
    end

    scenario 'User create app', js: true do
      platform = 'vkontakte'
      app_id = '789789'
      app_secret = 'quiz_app_secret'
      within '.form_add_quiz_app' do
        fill_in 'Platform', with: platform
        fill_in 'App id', with: app_id
        fill_in 'App secret', with: app_secret
      end
      click_on 'Add new app'
      expect(page).to have_content platform
      expect(page).to have_content app_id
      expect(page).to have_content app_secret
      expect(current_path).to eq edit_quiz_path(quiz)
    end

    context 'User create quiz app with invalid attributes' do
      scenario 'fields text is blank', js: true do
        within '.form_add_quiz_app' do
          fill_in 'Platform', with: ''
          fill_in 'App id', with: ''
          fill_in 'App secret', with: ''
        end
        click_on 'Add new app'
        expect(page).to have_content "Platform can't be blank"
        expect(page).to have_content "App can't be blank"
        expect(page).to have_content "App secret can't be blank"
      end
    end
  end
end
