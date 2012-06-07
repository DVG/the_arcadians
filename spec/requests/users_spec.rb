require 'spec_helper'

describe "Users" do
  before :each do
    @user = create(:user)
  end
  it 'should log the user in with their username instead of their email' do
    visit new_user_session_path
    page.should_not have_selector '#user_email'
    fill_in 'user_username', with: @user.username
    fill_in 'user_password', with: @user.password
    click_button 'Sign in'
    page.should have_content 'You have signed in successfully'
    current_path.should eq root_path
  end
end