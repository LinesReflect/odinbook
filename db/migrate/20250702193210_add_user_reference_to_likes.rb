class AddUserReferenceToLikes < ActiveRecord::Migration[8.0]
  def change
    add_reference :likes, :user
  end
end
