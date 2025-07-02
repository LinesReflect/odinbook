class CreateFollowRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :follow_requests do |t|
      t.references :requested, null: false, foreign_key: { to_table: :users }
      t.references :requester, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
