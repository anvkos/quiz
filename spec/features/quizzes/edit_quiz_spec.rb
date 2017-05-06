require_relative '../feature_helper'

feature 'Quiz editing', %q{
  In order to fix mistake
  As the author of the quiz
  I'd like ot be able to edit my quiz
} do
  given(:user) { create(:user) }
  given(:quiz) { create(:quiz, user: user) }

  describe 'Authenticated user' do
    context 'author' do
      before { sign_in(user) }

      scenario 'User view quiz' do
        visit quiz_path(quiz)
        expect(page).to have_content quiz.title
        expect(page).to have_content quiz.description
        expect(page).to have_content quiz.rules
      end

      scenario 'User view questions quiz' do
        questions = create_list(:question, 5, quiz: quiz)
        visit edit_quiz_path(quiz)
        questions.each do |question|
          expect(page).to have_content question.body
        end
      end

      scenario 'User view quiz with questions and answers to there' do
        question = create(:question, quiz: quiz)
        answers = create_list(:answer, 5, question: question)
        visit edit_quiz_path(quiz)
        expect(page).to have_content question.body
        answers.each do |answer|
          expect(page).to have_content answer.body
        end
      end

      scenario 'try to edit question', js: true do
        updated = {
          title: 'updated title',
          description: 'updated description',
          rules: 'updated rules',
          starts_on: Time.zone.now + 1.hours,
          ends_on: Time.zone.now + 1.day
        }
        visit edit_quiz_path(quiz)
        click_on 'Edit'
        within '.quiz' do
          updated.each { |field, value| fill_in "quiz[#{field}]", with: value }
          click_on 'Save'
        end
        updated.each do |attr, value|
          expect(page).to_not have_content quiz.send(attr)
          expect(page).to have_content value
        end
        within '.quiz-edit' do
          expect(page).to_not have_selector 'input'
          expect(page).to_not have_selector 'textarea'
        end
      end
    end
  end
end
