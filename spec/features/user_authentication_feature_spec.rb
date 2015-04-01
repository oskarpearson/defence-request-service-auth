require 'rails_helper'

RSpec.feature 'User authentication' do
    let!(:user) { create(:user) }

    specify 'can log in with valid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_button 'Sign in'
      expect(page).to have_content('You made it...')
    end

    specify 'cannot log in with invalid credentials' do
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'notarealpassword'
      click_button 'Sign in'
      expect(page).to_not have_content('You made it...')
    end

    specify 'receives a message when missing credentials for login' do
      visit new_user_session_path
      fill_in 'user_email', with: user.email
      click_button 'Sign in'
      expect(page).to have_content('Invalid email or password')
    end

  # context 'with no associated auth application access' do
  #   let(:permissions){ create(:permission, :with_gov_app_defence_request_service_auth) }
  #   let(:user) { permissions.user }
  #
  #   specify 'it does not allow authentication' do
  #     visit new_user_session_path
  #     fill_in 'user_email', with: user.email
  #     fill_in 'user_password', with: 'password'
  #     click_button 'Sign in'
  #     expect(page).to have_content('You do not have permission for this application')
  #   end
  # end
end
