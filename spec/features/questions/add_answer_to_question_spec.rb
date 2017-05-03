require_relative '../feature_helper'

feature 'Create answer', %q{
  In order to the participants had several variants of answers
  As a user
  I want to be able add answer
} do
  given(:quiz) { create(:quiz) }

  before do
    visit quiz_path(quiz)
    within '.question-fields' do
      fill_in 'Body', with: 'My question text'
    end
  end

  scenario 'User create answer', js: true do
    answer_text = 'My answer text'
    within '.answer-fields' do
      fill_in 'Body', with: answer_text
    end
    click_on 'Add'
    within '.question' do
      expect(page).to have_content answer_text
    end
    expect(current_path).to eq quiz_path(quiz)
  end

  describe 'User create answer with invalid attributes' do
    scenario 'Answer body text is blank', js: true do
      within '.answer-fields' do
        fill_in 'Body', with: ''
        check 'Correct'
      end
      click_on 'Add'
      expect(page).to have_content "Answers body can't be blank"
    end
  end
end
