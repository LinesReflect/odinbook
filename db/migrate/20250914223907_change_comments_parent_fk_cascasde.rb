class ChangeCommentsParentFkCascasde < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :comments, column: :parent_id

    add_foreign_key :comments, :comments, column: :parent_id, on_delete: :cascade
  end
end
