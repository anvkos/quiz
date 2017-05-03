require_relative '../feature_helper'

feature 'View quiz', %q{
  In order to read the text of the quiz
  As a user
  I want to be able to see the issue
} do
  given(:quiz) { create(:quiz) }

  scenario 'User view quiz' do
    visit quiz_path(quiz)
    expect(page).to have_content quiz.title
    expect(page).to have_content quiz.description
    expect(page).to have_content quiz.rules
  end

  scenario 'User view questions quiz' do
    questions = create_list(:question, 5, quiz: quiz)
    visit quiz_path(quiz)
    questions.each do |question|
      expect(page).to have_content question.body
    end
  end

  scenario 'User view quiz with questions and answers to there' do
    question = create(:question, quiz: quiz)
    answers = create_list(:answer, 5, question: question)
    visit quiz_path(quiz)
    expect(page).to have_content question.body
    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
