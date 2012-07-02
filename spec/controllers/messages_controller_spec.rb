require 'spec_helper'

describe UserControlPanel::MessagesController do
  describe 'GET #Index' do
    login_user
    it 'assigns the users recieved messages to the @messages variable' do
      my_message = create(:message, recipient: @user)
      someone_else_message = create(:message)
      my_sent_message = create(:message, sender: @user)
      get :index
      assigns(:messages).should eq [my_message]
    end
  end
end
