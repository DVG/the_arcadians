require 'spec_helper'

describe 'User Registrations' do
  context 'Register a new user' do
    it 'sets the role to registered for a new user' do
      r = create(:role, name: 'registered')
      visit new_user_registration_path
      fill_in 'user_username', with: 'SomeUser'
      fill_in 'user_email', with: 'foobar123@gmail.com'
      fill_in 'user_password', with: 'secret'
      fill_in 'user_password_confirmation', with: 'secret'
      click_button 'Sign up'
      u = User.last
      u.role.should eq r
    end
  end
end