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
        Timecop.freeze(Time.local(2012, 07, 02, 12, 0, 0)) do
          visit user_control_panel_messages_path
          within "#message_#{@recieved_message.id}" do
            page.should have_content '1 day ago'
          end
        end
        Timecop.return
      end
      it 'should show the message content for a recieved message' do
        visit user_control_panel_message_path(@recieved_message)
        page.should have_content @recieved_message.body
      end
      it 'should mark the message as read when viewing the message' do
        @recieved_message.read?.should be_false
        visit user_control_panel_message_path(@recieved_message)
        @recieved_message.reload
        @recieved_message.read?.should be_true
      end
      it 'should decrement the unread message count' do
        @user.unread_messages_count.should eq 1
        visit user_control_panel_message_path(@recieved_message)
        @user.unread_messages_count.should eq 0
      end
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
    before :each do
      @other_user = create(:user)
    end
    it 'shows a new message button' do
      visit user_control_panel_messages_path
      page.should have_link 'New Private Message'
    end
    it 'shows the new message form with a to, subject and body fields' do
      visit new_user_control_panel_message_path
      page.should have_selector '#message_recipient'
      page.should have_selector '#message_subject'
      page.should have_selector '#message_body'
    end
    it 'should allow a user to send a message to another user' do
      visit new_user_control_panel_message_path
      fill_in 'message_recipient', :with => @other_user.username
      fill_in 'message_subject', :with => "Hello World"
      fill_in 'message_body', :with => "Yes, Hello Indeed"
      click_button 'Send Message'
      message = Message.last
      @user.sent_messages.should include message
      @other_user.recieved_messages.should include message
    end 
    it 'will increase the unread message count of the recipient by 1' do
      @other_user.unread_messages_count.should eq 0
      visit new_user_control_panel_message_path
      fill_in 'message_recipient', :with => @other_user.username
      fill_in 'message_subject', :with => "Hello World"
      fill_in 'message_body', :with => "Yes, Hello Indeed"
      click_button 'Send Message'
      @other_user.unread_messages_count.should eq 1
    end
    context 'reply' do
      before :each do
        @message = create(:message, sender: @user, recipient: @other_user)
      end
      it 'should show a reply form below the message' do
        visit user_control_panel_message_path(@message)
        page.should have_selector "#reply_message_form"
      end
      it 'should prepend the original subject with \'RE: \'' do
        visit user_control_panel_message_path(@message)
        find("#message_subject").value.should eq "RE: #{@message.subject}"
      end
      it 'should set the original sender as the recipient' do
        visit user_control_panel_message_path(@message)
        find("#message_recipient").value.should eq @message.sender.username
      end
      it 'should allow a user to reply to the message'
      it 'should set the original recipient as the sender'
    end
    
  end
  context 'delete' do
    it 'should allow a user to destroy a message'
  end
end