class AddPostsCounterToForum < ActiveRecord::Migration
  def change
    add_column :forums, :posts_counter, :integer, :default => 0

  end
end
