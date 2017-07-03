require_relative '../feature_helper'

feature 'Delete point', %q{
  In order to remove the incorrect point
  As a user
  I want to be able to delete the point
} do
  given(:user) { create(:user) }
  given(:quiz) { create(:quiz, user: user) }
  given!(:point) { create(:point, quiz: quiz, time: 33, score: 789) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit edit_quiz_path(quiz)
    end

    scenario 'user try delete point', js: true do
      within '.point' do
        click_on 'Delete'
      end
      expect(page).to_not have_content point.time
      expect(page).to_not have_content point.score
      expect(page).to have_content 'Point was successfully destroyed.'
    end
  end
end
