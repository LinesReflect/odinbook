class RenameAuthImageUrlToProfilePictureUrl < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :auth_image_url, :profile_picture_url
  end
end
