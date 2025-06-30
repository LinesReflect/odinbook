class ChangeFollowshipToFollow < ActiveRecord::Migration[8.0]
  def change
    rename_table :followships, :follows
  end
end
