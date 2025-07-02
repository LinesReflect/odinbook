class AddPostReferenceToLikes < ActiveRecord::Migration[8.0]
  def change
    add_reference :likes, :post
  end
end
