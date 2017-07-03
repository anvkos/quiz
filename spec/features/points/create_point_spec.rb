require_relative '../feature_helper'

feature 'Create point', %q{
  In order  to the participants to receive points for answers
  As the author of the quiz
  I want to add time control points
} do
  given(:user) { create(:user) }
  given(:quiz) { create(:quiz, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit edit_quiz_path(quiz)
    end

    scenario 'User create point', js: true do
      time = 29
      score = 49
      within '.form_add_point' do
        fill_in 'Time point', with: time
        fill_in 'Score', with: score
      end
      click_on 'Add new point'
      expect(page).to have_content time
      expect(page).to have_content score
      expect(current_path).to eq edit_quiz_path(quiz)
    end

    context 'User create score with invalid attributes' do
      scenario 'fields text is blank', js: true do
        within '.form_add_point' do
          fill_in 'Time point', with: ''
          fill_in 'Score', with: ''
        end
        click_on 'Add new point'
        expect(page).to have_content "Time can't be blank"
        expect(page).to have_content "Score can't be blank"
      end
    end
  end
end
