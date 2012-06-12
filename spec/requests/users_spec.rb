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
  context "guest" do
    it 'does not allow guests to make new threads'
    it 'does not show the quick reply section for a guest'
    it 'does not allow a guest to reply'
  end
  context 'registered' do
    it 'allows a registered user to make a new thread'
    it 'allows a registered user to reply to existing threads'
    it 'shows the quick reply section for a registered user'
    it 'allows a registered user to edit their own post'
    it 'does not allow a registered user to edit another posters post'
  end
  context 'admin' do
    it 'allows an admin to make a new thread'
    it 'allows an admin to reply to existing threads'
    it 'allows an admin to see the quick reply section'
    it 'allows an admin to edit their own post'
    it 'allows an admin to edit another posters post'
    it 'allows an admin to perform a quick reply'
  end
end