class User < ActiveRecord::Base
  has_many :posts
  has_many :discussions
  belongs_to :role
  validates_uniqueness_of :email
  validates_presence_of :username
  validates_uniqueness_of :username
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username
  
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
end
