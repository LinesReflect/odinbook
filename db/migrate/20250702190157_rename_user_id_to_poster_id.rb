class RenameUserIdToPosterId < ActiveRecord::Migration[8.0]
  def change
    rename_column :posts, :user_id, :poster_id
  end
end
