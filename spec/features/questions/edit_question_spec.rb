require_relative '../feature_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As a user
  I'd like ot be able to edit question
} do
  given(:quiz) { create(:quiz) }
  given!(:question) { create(:question, quiz: quiz) }

  describe 'User edit question' do
    before do
      visit quiz_path(quiz)
    end

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
