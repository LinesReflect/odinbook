class FollowRequest < ApplicationRecord
  belongs_to :requested, class_name: "User"
  belongs_to :requester, class_name: "User"
end
