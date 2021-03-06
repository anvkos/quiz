require_relative '../feature_helper'

feature 'User sign out', %q{
  In order to complete the work of the session
  As a user
  I want to be able to go out and the system
} do
  given(:user) { create(:user) }

  scenario 'Authenticated user try to sign out' do
    sign_in(user)
    click_on 'Sign out'
    expect(page).to have_content 'Signed out successfully.'
    expect(page).to_not have_content user.name
    expect(current_path).to eq root_path
  end
end
