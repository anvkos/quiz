require_relative '../feature_helper'

feature 'Create question', %q{
  In order to the participants had something to answer
  As the author of the quiz
  I want to be able add question
} do
  given(:user) { create(:user) }
  given(:quiz) { create(:quiz, user: user) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit edit_quiz_path(quiz)
    end

    scenario 'User create question', js: true do
      question_text = 'My question text'
      within '.question-fields' do
        fill_in 'Body', with: question_text
      end
      click_on 'Add new question'
      expect(page).to have_content question_text
      expect(current_path).to eq edit_quiz_path(quiz)
    end

    context 'User create question with invalid attributes' do
      scenario 'body text is blank', js: true do
        within '.question-fields' do
          fill_in 'Body', with: ''
        end
        click_on 'Add new question'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end
end
