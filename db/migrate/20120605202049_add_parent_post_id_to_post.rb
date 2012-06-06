class AddParentPostIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :parent_post_id, :integer

  end
end
