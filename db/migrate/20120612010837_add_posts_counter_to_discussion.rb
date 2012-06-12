class AddPostsCounterToDiscussion < ActiveRecord::Migration
  def change
    add_column :discussions, :posts_counter, :integer

  end
end
