class AddGravatarUrlToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :gravatar_url, :string
  end
end
