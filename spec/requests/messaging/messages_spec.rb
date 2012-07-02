require 'spec_helper'

describe 'Messages' do
  # Requires login to access private messaging
  before :each do
    @user = create(:user)
    visit new_user_session_path
    fill_in 'user_username', :with => @user.username
    fill_in 'user_password', :with => @user.password
    click_button 'Sign in'
  end
  
  context 'read' do
    context 'inbox' do
      before :each do
        Timecop.freeze(Time.local(2012, 07, 01, 12, 0, 0)) # July 1, 2012, 12:00 pm
        @other_user = create(:user)
        @recieved_message = create(:message, recipient: @user, sender: @other_user)
        @sent_message = create(:message, sender: @user, recipient: @other_user)
        Timecop.return
      end
      it 'should show a users recieved messages in the inbox' do
        visit user_control_panel_messages_path
        within "#messages_table" do
          page.should have_content @recieved_message.subject
          page.should_not have_content @sent_message.subject
        end
      end
      it 'should display the subject as a link to view the message' do
        visit user_control_panel_messages_path
        within "#messages_table" do
          page.should have_link @recieved_message.subject
        end
      end
      it 'should display the user that sent the message as a link' do
        visit user_control_panel_messages_path
        within "#messages_table" do
          page.should have_link @recieved_message.sender.username
        end
      end
      it 'should display how long ago the message was recieved' do
        visit user_control_panel_messages_path
        Timecop.freeze(Time.local(2012, 07, 02, 12, 0, 0))
        puts "Time.now: #{Time.now}"
        puts "Message Created At: #{@recieved_message.created_at}"
        within "#message_#{@recieved_message.id}" do
          page.should have_content '1 day ago'
        end
        Timecop.return
      end
      it 'should show the message content for a recieved message' do
        visit user_control_panel_message_path(@recieved_message)
        page.should have_content @recieved_message.body
      end
      it 'should mark the message as read when viewing the message'
      it 'should decrement the unread message count'
    end
    context 'sent' do
      before :each do
        @other_user = create(:user)
        @recieved_message = create(:message, recipient: @user, sender: @other_user)
        @sent_message = create(:message, sender: @user, recipient: @other_user)
      end
      it 'should display the messages sent by the user in the outbox' do
        visit sent_user_control_panel_messages_path
        within "#messages_table" do
          page.should_not have_content @recieved_message.subject
          page.should have_content @sent_message.subject
        end
      end
    end
  end
  context 'create' do
    it 'should allow a user to send a message to another user'
    it 'should allow a user to reply to a message sent by another user'
  end
  context 'delete' do
    it 'should allow a user to destroy a message'
  end
end