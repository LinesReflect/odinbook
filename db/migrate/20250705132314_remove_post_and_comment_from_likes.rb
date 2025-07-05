class RemovePostAndCommentFromLikes < ActiveRecord::Migration[8.0]
  def change
    remove_reference :likes, :post
    remove_reference :likes, :comment
  end
end
