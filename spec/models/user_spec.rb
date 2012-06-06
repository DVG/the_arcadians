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
end