# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
count = 10
100.times do
  next if User.find_by(username: "Lines#{count}")
  next if User.find_by(email: "Lines#{count}@test.com")
  User.find_or_create_by!(username: "Lines#{count}", email: "Lines#{count}@test.com") do |user|
    user.password = 'password'
    user.password_confirmation = 'password'
    user.avatar.attach(io: File.open("app/assets/images/blank-profile-picture-973460_1920.png"), filename: "blank-profile-picture-973460_1920.png", content_type: "avatar/png")
  end
  count += 1
end
