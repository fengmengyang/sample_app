class RemoveIndexToRelationship < ActiveRecord::Migration
  def change
    remove_index :relationships,:follower_id
  end
end
