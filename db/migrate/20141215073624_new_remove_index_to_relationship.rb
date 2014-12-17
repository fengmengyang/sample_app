class NewRemoveIndexToRelationship < ActiveRecord::Migration
  def change
    remove_index :relationships,[:follower_id,:following_id]
    add_index :relationships,:follower_id
  end
end
