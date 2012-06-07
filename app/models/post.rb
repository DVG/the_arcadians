class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :thread, :class_name => 'Post', :foreign_key => 'parent_post_id'
  belongs_to :forum
  
  def self.threads
    where(:parent_post_id => nil)
  end
  
  def self.thread_posts(thread)
    where('id = ? OR parent_post_id = ?', thread.id, thread.id)
  end
end
