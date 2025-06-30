class CreateFollowships < ActiveRecord::Migration[8.0]
  def change
    create_table :followships do |t|
      t.references :followed, null: false, foreign_key: { to_table: :users }
      t.references :follower, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
