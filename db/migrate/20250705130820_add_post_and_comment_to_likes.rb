class AddPostAndCommentToLikes < ActiveRecord::Migration[8.0]
  def change
    add_reference :likes, :post
    add_reference :likes, :comment
  end
end
