class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: true
  validates :username, uniqueness: true

  has_many :sent_follows, class_name: "Follow", foreign_key: :follower_id
  has_many :recieved_follows, class_name: "Follow", foreign_key: :followed_id

  has_many :sent_follow_requests, through: :sent_follows, source: :followed
  has_many :recieved_follow_requests, through: :recieved_follows, source: :follower

  has_many :followings, through: :sent_follows, source: :followed
  has_many :followers, through: :recieved_follows, source: :follower

  def follow(other_user)
    self.sent_follows.build(followed: other_user)
  end

  def unfollow(other_user)
    Follow.find_by(followed: other_user, follower: self).destroy
  end

  def accept_follow_request(other_user)
    other_user.follow(self)
  end
end
