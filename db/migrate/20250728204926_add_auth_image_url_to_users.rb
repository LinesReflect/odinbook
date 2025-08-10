class AddAuthImageUrlToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :auth_image_url, :string
  end
end
