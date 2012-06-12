class AddOriginalPostIdToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :original_post_id, :integer

  end
end
