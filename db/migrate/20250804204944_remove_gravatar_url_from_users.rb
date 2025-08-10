class RemoveGravatarUrlFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :gravatar_url
  end
end
