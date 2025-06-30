class CreateFollowships < ActiveRecord::Migration[8.0]
  def change
    create_table :followships do |t|
      t.references :followed, null: false, foreign_key: true
      t.references :follower, null: false, foreign_key: true

      t.timestamps
    end
  end
end
