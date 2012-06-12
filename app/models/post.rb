class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :discussion,
             :touch => true,
             :counter_cache => :posts_counter
  has_one    :forum, :through => :discussion,
             :counter_cache => :posts_counter
end
