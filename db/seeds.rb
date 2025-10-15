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
count = 950
15.times do
  r = FollowRequest.new(requester: User.where(id: [ 141..210 ]).sample, requested: User.find(4))
  next if r.requester == User.find(4)
  next if r.requester.follows?(r.requested)
  r.save
end


# 100.times do
# u = User.create(username: "lines#{count}", email: "lines#{count}@test.com", password: "Reflect")
# u.avatar.attach(io: File.open("app/assets/images/blank-profile-picture-973460_1920.png"), filename: "blank-profile-picture-973460_1920.png", content_type: "avatar/png")
# count+=1
# end
