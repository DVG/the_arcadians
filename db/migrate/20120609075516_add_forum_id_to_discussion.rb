class AddForumIdToDiscussion < ActiveRecord::Migration
  def change
    add_column :discussions, :forum_id, :integer

  end
end
