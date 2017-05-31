require_relative '../feature_helper'

feature 'Sign in OAuth', %q{
  In order to be able to sign in through account social network
  As non-authenticated user
  I want to be able to sign in through my social network account
} do
  context 'provider received email' do
    scenario 'sign in through facebook' do
      received_email = 'email@example.test'
      OmniAuth.config.add_mock(:facebook, uid: '123456', info: { email: received_email })
      visit new_user_session_path
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'For complete the registration your need to confirm email!'
      expect(page).to have_content 'Send confirmation instructions'

      fill_in 'Email', with: received_email
      click_on 'Send confirmation instructions'
      open_email(received_email)
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(current_path).to eq root_path
    end
  end

  scenario 'email not confirmed' do
    email = 'email@example.test'
    OmniAuth.config.add_mock(:facebook, uid: '123456')
    visit new_user_session_path
    click_on 'Sign in with Facebook'

    fill_in 'Email', with: email
    click_on 'Send confirmation instructions'

    visit new_user_session_path
    click_on 'Sign in with Facebook'
    expect(page).to have_content 'For complete the registration your need to confirm email!'
    expect(page).to have_content 'Send confirmation instructions'
  end
end
