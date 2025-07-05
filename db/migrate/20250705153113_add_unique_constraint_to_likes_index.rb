class AddUniqueConstraintToLikesIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :likes, [ :user_id, :likeable_id, :likeable_type ]
    add_index :likes, [ :user_id, :likeable_id, :likeable_type ], unique: true
  end
end
