class User < ActiveRecord::Base
  has_many   :posts
  has_many   :discussions
  belongs_to :role
  has_many   :recieved_messages, :class_name => 'Message',
             :foreign_key => 'recipient_id'
  has_many   :sent_messages, :class_name => 'Message',
             :foreign_key => 'sender_id'
             
  validates_uniqueness_of :email
  validates_presence_of :username
  validates_uniqueness_of :username
  
  before_create :set_role
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  def role_symbols
    [self.role.name.to_sym]
  end
  
  def display_role?
    if ["registered"].include? self.role.name
      false
    else
      true
    end
  end
  
  def unread_messages_count
    self.recieved_messages.where(:read => false).count
  end
  
  private
  def set_role
    if self.role.nil?
      self.role = Role.find_by_name('registered')
    end
  end
end
