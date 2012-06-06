class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :thread, :class_name => 'Post', :foreign_key => 'parent_post_id'
  belongs_to :forum
  
  def self.threads
    where(:parent_post_id => nil)
  end
end
