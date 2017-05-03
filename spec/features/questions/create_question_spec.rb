require_relative '../feature_helper'

feature 'Create question', %q{
  In order to the participants had something to answer
  As a user
  I want to be able add question
} do
  given(:quiz) { create(:quiz) }

  scenario 'User create question', js: true do
    visit quiz_path(quiz)
    question_text = 'My question text'
    within '.question-fields' do
      fill_in 'Body', with: question_text
    end
    click_on 'Add'
    expect(page).to have_content question_text
    expect(current_path).to eq quiz_path(quiz)
  end

  describe 'User create question with invalid attributes' do
    before { visit quiz_path(quiz) }

    scenario 'body text is blank', js: true do
      within '.question-fields' do
        fill_in 'Body', with: ''
      end
      click_on 'Add'
      expect(page).to have_content "Body can't be blank"
    end
  end
end
