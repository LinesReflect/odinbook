class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2, :twitter2 ]

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

  has_many :likes

  has_many :comments

  has_many :commented_on_posts, through: :comments, source: :post

  def self.from_omniauth(auth)
    email = auth.info.email
    username = auth.info.nickname || auth.info.name || "user_#{auth.uid}"
    provider = auth.provider
    uid = auth.uid

    user = User.find_by(provider: provider, uid: uid)
    return user if user.present?

    if email.present?
      existing_user = User.find_by(email: email)
      if existing_user
        existing_user.update(provider: provider, uid: uid) if existing_user.provider.nil?
        return existing_user
      end
    end

    user = User.create(
      provider: provider,
      uid: uid,
      email: email || "#{uid}@change-me.com",
      username: username,
      password: Devise.friendly_token[0, 20]
    )
  end

  def follow(other_user)
    return if self == other_user
    return if self.sent_follows.exists?(followed: other_user)

    self.sent_follows.create(followed: other_user)
  end

  def follows?(other_user)
    self.followers.include?(other_user)
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

  def like(obj)
    self.likes.create(likeable_id: obj.id, likeable_type: obj.class.name)
  end

  def liked_posts
    self.likes.where(likeable_type: "Post")
  end

  def liked_comments
    self.likes.where(likeable_type: "Comment")
  end

  def unlike(obj)
    like = Like.find_by(user: self, likeable_id: obj.id, likeable_type: obj.class.name)
    like.destroy if like
  end

  def followings_posts
    self.followings.map do |following|
      following.posts
    end
  end

  def feed
    self.posts + self.followings_posts.flatten
  end
end
