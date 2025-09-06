class Post < ApplicationRecord
  belongs_to :poster, class_name: "User"
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :body, presence: true

  scope :user_feed, ->(user) { where(poster: user.followings.pluck(:id) + [ user.id ]) }
end
