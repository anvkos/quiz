require_relative '../feature_helper.rb'

feature 'Create quiz', %q{
  To conduct a quiz
  As a user
  I want to be able to create it
} do

  scenario 'user creates quiz' do
    visit new_quiz_path
    fill_in 'Title', with: 'Title new quiz'
    fill_in 'Description', with: 'description quiz'
    fill_in 'Rules', with: 'rules quiz'
    fill_in 'Starts on', with: Time.now
    fill_in 'Ends on', with: Time.now
    click_on 'Create'

    expect(page).to have_content 'Quiz was successfully created.'
  end
end
