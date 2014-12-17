class UpdateIndexRelationship < ActiveRecord::Migration
  def change
    add_index :relationships, :followed_id
    add_index :relationships, [:followed_id, :follower_id],unique: true
  end
end
