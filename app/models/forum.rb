class Forum < ActiveRecord::Base
  has_many :posts
  
  validates_presence_of :title
  validates_uniqueness_of :title
  
  def threads
    posts.threads
  end
end
