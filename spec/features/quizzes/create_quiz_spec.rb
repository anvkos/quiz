require_relative '../feature_helper.rb'

feature 'Create quiz', %q{
  To conduct a quiz
  As on authenticated user
  I want to be able to create it
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user creates quiz' do
    sign_in(user)
    visit new_quiz_path
    fill_in 'Title', with: 'Title new quiz'
    fill_in 'Description', with: 'description quiz'
    fill_in 'Rules', with: 'rules quiz'
    fill_in 'Starts on', with: Time.now
    fill_in 'Ends on', with: Time.now
    fill_in 'Once per', with: 1.days.to_i
    fill_in 'Time limit', with: 15.minutes.to_i
    fill_in 'Time answer', with: 15
    check 'No mistakes'
    click_on 'Create'

    expect(page).to have_content 'Quiz was successfully created.'
  end

  scenario 'Non-authenticated user ties to create question' do
    visit root_path
    expect(page).to_not have_content 'Create Quiz'
  end
end
