require_relative '../feature_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As the author of the quiz
  I'd like ot be able to edit answer
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

    scenario 'sees link to Edit' do
      within '.answer' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'user try to edit answer', js: true do
      updated_text = 'edited answer'
      within '.answer' do
        click_on 'Edit'
        fill_in 'answer[body]', with: updated_text
        check 'answer[correct]'
        click_on 'Save'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Correct'
        within '.answer-edit' do
          expect(page).to_not have_selector 'input'
          expect(page).to_not have_selector 'checkbox'
        end
      end
    end

    context 'try update to answer with invalid attributes' do
      scenario 'body text is blank', js: true do
        within ".answer-#{answer.id}" do
          click_on 'Edit'
          fill_in 'answer[body]', with: ''
          click_on 'Save'
        end
        expect(page).to have_content "Body can't be blank"
      end
    end
  end
end
