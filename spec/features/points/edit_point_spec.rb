require_relative '../feature_helper'

feature 'Point editing', %q{
  In order to fix mistake
  As  the author of the quiz
  I'd like ot be able to edit time point
} do
  given(:user) { create(:user) }
  given(:quiz) { create(:quiz, user: user) }
  given!(:point) { create(:point, quiz: quiz) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit edit_quiz_path(quiz)
    end

    describe 'User edit point' do
      scenario 'sees link to Edit' do
        within '.point' do
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'try to edit point', js: true do
        updated_point = {
          time: 79,
          score: 889,
          app_secret: 'updated_app_secret'
        }
        within '.point' do
          click_on 'Edit'
          fill_in 'point[time]', with: updated_point[:time]
          fill_in 'point[score]', with: updated_point[:score]
          click_on 'Save'
          expect(page).to_not have_content point.time
          expect(page).to_not have_content point.score
          expect(page).to have_content updated_point[:time]
          expect(page).to have_content updated_point[:score]
          within '.point-edit' do
            expect(page).to_not have_selector 'input'
          end
        end
      end

      context 'try update to point with invalid attributes' do
        scenario 'body text is blank', js: true do
          within ".point-#{point.id}" do
            click_on 'Edit'
            fill_in 'point[time]', with: ''
            fill_in 'point[score]', with: ''
            click_on 'Save'
          end
          expect(page).to have_content "Time can't be blank"
          expect(page).to have_content "Score can't be blank"
        end
      end
    end
  end
end
