class UserControlPanel::MessagesController < ApplicationController
  layout 'user_control_panel', :except => [:new]
  def index
    @messages = current_user.recieved_messages
  end
  
  def sent
    @messages = current_user.sent_messages
  end
  
  def show
    @message = Message.find(params[:id])
    @message.mark_read
    @reply = @message.create_reply
  end
  
  def new
    @message = Message.new
  end
  
  def create
    @message = Message.new do |m|
      m.sender = current_user
      m.recipient = User.find_by_username(params[:message][:recipient])
      m.subject = params[:message][:subject]
      m.body = params[:message][:body]
      m.read = false
    end
    if @message.save
      redirect_to(user_control_panel_messages_path, :notice => "You're private message to #{@message.recipient.username} was sent!")
    else
      render 'new'
    end
  end
  
  def destroy
    
  end
end
