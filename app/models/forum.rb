class Forum < ActiveRecord::Base
  #has_many :posts
  has_many :discussions
  has_many :posts, :through => :discussions
  validates_presence_of :title
  validates_uniqueness_of :title
  
  def threads
    posts.threads
  end
end
