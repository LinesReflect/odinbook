class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: true
  validates :username, uniqueness: true

  has_many :sent_friendships, class_name: "Friendship", foreign_key: :user_a_id
  has_many :received_friendships, class_name: "Friendship", foreign_key: :user_b_id

  has_many :sent_friends, through: :sent_friendships, source: :user_b
  has_many :received_friends, through: :received_friendships, source: :user_a

  def friendships
    Friendship.where("user_a_id = ? OR user_b_id = ?", self.id, self.id)
  end

  def friends
    self.sent_friends + self.received_friends
  end
end
