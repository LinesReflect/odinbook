class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: true
  validates :username, presence: true, uniqueness: true

  has_many :sent_follow_requests, class_name: "FollowRequest", foreign_key: :requester_id
  has_many :received_follow_requests, class_name: "FollowRequest", foreign_key: :requested_id

  has_many :outgoing_follow_requests, through: :sent_follow_requests, source: :requested
  has_many :incoming_follow_requests, through: :received_follow_requests, source: :requester

  has_many :sent_follows, class_name: "Follow", foreign_key: :follower_id
  has_many :received_follows, class_name: "Follow", foreign_key: :followed_id

  has_many :followings, through: :sent_follows, source: :followed
  has_many :followers, through: :received_follows, source: :follower

  has_many :posts, foreign_key: :poster_id

  def follow(other_user)
    return if self == other_user
    return if self.sent_follows.exists?(followed: other_user)

    self.sent_follows.create(followed: other_user)
  end

  def unfollow(other_user)
    return if self == other_user

    follow = Follow.find_by(followed: other_user, follower: self)
    safely_destroy(follow)
  end

  def send_follow_request(other_user)
    return if self == other_user
    return if sent_follow_requests.exists?(requested: other_user)

    self.sent_follow_requests.create(requested: other_user)
  end

  def cancel_sent_follow_request(other_user)
    return if self == other_user

    request = FollowRequest.find_by(requested: other_user, requester: self)
    safely_destroy(request)
  end

  def accept_follow_request(other_user)
    return if self == other_user

    other_user.follow(self)
    request = FollowRequest.find_by(requested: self, requester: other_user)
    safely_destroy(request)
  end

  def deny_follow_request(other_user)
    return if self == other_user

    request = FollowRequest.find_by(requested: self, requester: other_user)
    safely_destroy(request)
  end

  def safely_destroy(obj)
    obj.destroy if obj
  end
end
