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

      scenario 'try to edit quiz', js: true do
        quiz = create(
          :quiz,
          user: user,
          once_per: 7200,
          time_limit: 3600,
          time_answer: 312,
          question_randomly: true
        )
        updated = {
          title: 'updated title',
          description: 'updated description',
          rules: 'updated rules',
          starts_on: Time.zone.now + 1.hours,
          ends_on: Time.zone.now + 1.day,
          once_per: 1.days.to_i,
          time_limit: 15.minutes.to_i,
          time_answer: 15,
          no_mistakes: true,
          question_randomly: false
        }
        visit edit_quiz_path(quiz)
        click_on 'Edit'
        within '.quiz' do
          updated.except(:no_mistakes, :question_randomly).each { |field, value| fill_in "quiz[#{field}]", with: value }
          check 'No mistakes'
          uncheck 'Question randomly'
          click_on 'Save'
        end
        updated.except(:no_mistakes, :question_randomly).each do |attr, value|
          expect(page).to_not have_content quiz.send(attr)
          expect(page).to have_content value
        end
        expect(page).to have_content 'No mistakes: Yes'
        expect(page).to have_content 'Question randomly: No'
        within '.quiz-edit' do
          expect(page).to_not have_selector 'input'
          expect(page).to_not have_selector 'textarea'
        end
      end
    end
  end
end
