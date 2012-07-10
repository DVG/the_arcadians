class Message < ActiveRecord::Base
  belongs_to :sender, :class_name => "User",
             :foreign_key => 'sender_id'
  belongs_to :recipient, :class_name => "User",
             :foreign_key => 'recipient_id'
  validates_presence_of :subject
  validates_presence_of :body
  validates_presence_of :recipient
  
  def mark_read
    unless self.read?
      self.read = true
      self.save!
    end
  end
  
  def create_reply
    r = Message.new
    r.subject = "RE: #{self.subject}"
    r.recipient = self.sender
    r.sender = self.recipient
    r
  end
end
