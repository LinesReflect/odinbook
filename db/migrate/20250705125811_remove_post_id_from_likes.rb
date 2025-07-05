class RemovePostIdFromLikes < ActiveRecord::Migration[8.0]
  def change
    remove_column :likes, :post_id
  end
end
