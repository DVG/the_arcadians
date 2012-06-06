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
end