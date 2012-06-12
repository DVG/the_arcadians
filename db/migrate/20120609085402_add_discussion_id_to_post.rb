class AddDiscussionIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :discussion_id, :integer

  end
end
