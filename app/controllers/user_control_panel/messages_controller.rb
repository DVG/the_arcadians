class UserControlPanel::MessagesController < ApplicationController
  layout 'user_control_panel'
  def index
    @messages = current_user.recieved_messages
  end
  
  def sent
    @messages = current_user.sent_messages
  end
  
  def show
    @message = Message.find(params[:id])
    @message.mark_read
  end
  
  def new
    
  end
  
  def destroy
    
  end
end
