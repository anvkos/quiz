require_relative '../feature_helper'

feature 'Delete answer', %q{
  In order to remove the incorrect answer
  As the author of the quiz
  I want to be able to delete the answer
} do
  given(:user) { create(:user) }
  given(:quiz) { create(:quiz, user: user) }
  given(:question) { create(:question, quiz: quiz) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit edit_quiz_path(quiz)
    end

    scenario 'user try delete answer', js: true do
      within '.answer' do
        click_on 'Delete'
      end
      expect(page).to_not have_content answer.body
      expect(page).to have_content 'Answer was successfully destroyed.'
    end
  end
end
