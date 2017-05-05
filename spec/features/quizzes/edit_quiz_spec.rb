require_relative '../feature_helper'

feature 'Quiz editing', %q{
  In order to fix mistake
  As a user
  I'd like ot be able to edit quiz
} do
  given(:quiz) { create(:quiz) }

  before { visit quiz_path(quiz) }

  scenario 'try to edit question', js: true do
    updated = {
      title: 'updated title',
      description: 'updated description',
      rules: 'updated rules',
      starts_on: Time.zone.now + 1.hours,
      ends_on: Time.zone.now + 1.day
    }
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
