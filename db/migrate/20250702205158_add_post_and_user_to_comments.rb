class AddPostAndUserToComments < ActiveRecord::Migration[8.0]
  def change
    add_reference :comments, :post
    add_reference :comments, :user
  end
end
