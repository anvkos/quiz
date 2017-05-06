require_relative '../feature_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an of answer
  I'd like ot be able to edit answer
} do
  given(:quiz) { create(:quiz) }
  given(:question) { create(:question, quiz: quiz) }
  given!(:answer) { create(:answer, question: question) }

  before { visit quiz_path(quiz) }

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
