require 'spec_helper'

describe User do
  it 'returns the email of the user' do
    user = create(:user, email: 'user@example.com')
    user.email.should eq 'user@example.com'
  end
  it 'is not valid without an email' do
    user = build(:user, email: nil)
    user.should_not be_valid
  end
  it 'requires a unique email' do
    user_one = create(:user)
    user_two = build(:user, email: user_one.email)
    user_two.should_not be_valid
  end
  it 'should require a username' do
    user = build(:user, username: nil)
    user.should_not be_valid
  end
  it 'should require a unique username' do
    user = create(:user)
    another_user = build(:user, username: user.username)
    another_user.should_not be_valid
  end
  it 'should return the registered role' do
    user = create(:user, role: create(:registered_role))
    user.role.name.should eq 'registered'
  end
  it 'should return the admin role' do
    user = create(:user, role: create(:admin_role))
    user.role.name.should eq 'admin'
  end
  it 'should return the jailed role' do
    user = create(:user, role: create(:jailed_role))
    user.role.name.should eq 'jailed'
  end
  it 'should return the moderator role' do
    user = create(:user, role: create(:moderator_role))
    user.role.name.should eq 'moderator'
  end
  it 'should return the registered role as a symbol' do
    user = create(:user, role: create(:registered_role))
    user.role_symbols.should eq [:registered]
  end
  context 'display role?' do
    it 'returns false if registered' do
      user = create(:user, role: create(:registered_role))
      user.display_role?.should eq false
    end
    it 'returns true if a moderator' do
      user = create(:user, role: create(:moderator_role))
      user.display_role?.should eq true
    end
    it 'returns true if a admin' do
      user = create(:user, role: create(:admin_role))
      user.display_role?.should eq true
    end
  end
  
  context 'Private Messages' do
    before :each do
      @user = create(:user)
      @message = create(:message, recipient: @user)
      @sent_message = create(:message, sender: @user)
    end
    it 'returns a list of messages sent to the user' do
      @user.recieved_messages.should eq [@message]
    end
    it 'returns a list of messages sent by the user' do
      @user.sent_messages.should eq [@sent_message]
    end
    it 'returns a count of unread messages' do
      @user.unread_messages_count.should eq 1
    end
  end
end