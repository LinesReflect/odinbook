class Post < ApplicationRecord
  belongs_to :poster, class_name: "User"
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, -> { order(likes_count: :desc, replies_count: :desc, created_at: :desc) }, dependent: :destroy

  validates :body, presence: true

  scope :user_feed, ->(user) { where(poster: user.followings.pluck(:id) + [ user.id ]) }
end
