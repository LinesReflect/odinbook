class AddIndexToLikes < ActiveRecord::Migration[8.0]
  def change
    add_index :likes, [ :user_id, :likeable_id, :likeable_type ]
  end
end
