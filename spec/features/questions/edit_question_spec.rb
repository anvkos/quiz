require_relative '../feature_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As  the author of the quiz
  I'd like ot be able to edit question
} do
  given(:user) { create(:user) }
  given(:quiz) { create(:quiz, user: user) }
  given!(:question) { create(:question, quiz: quiz) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit edit_quiz_path(quiz)
    end

    describe 'User edit question' do
      scenario 'sees link to Edit' do
        within '.question' do
          expect(page).to have_link 'Edit'
        end
      end

      scenario 'try to edit question', js: true do
        updated_text = 'edited question'
        within '.question' do
          click_on 'Edit'
          fill_in 'question[body]', with: updated_text
          click_on 'Save'
          expect(page).to_not have_content question.body
          expect(page).to have_content updated_text
          within '.question-edit' do
            expect(page).to_not have_selector 'input'
          end
        end
      end

      context 'try update to question with invalid attributes' do
        scenario 'body text is blank', js: true do
          within ".question-#{question.id}" do
            click_on 'Edit'
            fill_in 'question[body]', with: ''
            click_on 'Save'
          end
          expect(page).to have_content "Body can't be blank"
        end
      end
    end
  end
end
