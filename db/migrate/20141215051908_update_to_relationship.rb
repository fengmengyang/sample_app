class UpdateToRelationship < ActiveRecord::Migration
  def change
    remove_column :relationships,:following_id,:integer
    add_column :relationships,:followed_id,:integer
  end
end
