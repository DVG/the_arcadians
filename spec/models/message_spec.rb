require 'spec_helper'

describe Message do
  it 'should have a subject' do
    m = build(:message, subject: 'Winter is Coming')
    m.subject.should eq 'Winter is Coming'
  end
  it 'should have a body' do
    m = build(:message, body: 'Winter is Coming')
    m.body.should eq 'Winter is Coming'
  end
  it 'should have a sender' do
    sender = build(:user)
    m = build(:message, sender: sender)
    m.sender.should eq sender
  end
  it 'should have a recipient' do
    recipient = build(:user)
    m = build(:message, recipient: recipient)
    m.recipient.should eq recipient
  end
  it 'should be invalid without a subject' do
    m = build(:message, subject: nil)
    m.should_not be_valid
  end
  it 'should be invalid without a body' do
    m = build(:message, body: nil)
    m.should_not be_valid
  end
  it 'should be invalid without a recipient' do
    m = build(:message, recipient: nil)
    m.should_not be_valid
  end
  it 'should be marked as read or unread' do
    m = build(:message)
    m.read?.should be_false
  end
  it 'should mark the message as read' do
    m = build(:message)
    m.mark_read
    m.read?.should be_true
  end
  it 'should not change a message that is already read' do
    m = build(:message, read: true)
    m.mark_read
    m.read?.should be_true
  end
end
