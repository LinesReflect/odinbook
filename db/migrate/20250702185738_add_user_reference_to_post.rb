class AddUserReferenceToPost < ActiveRecord::Migration[8.0]
  def change
    add_reference :posts, :user
  end
end
