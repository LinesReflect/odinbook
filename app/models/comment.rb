class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy

  belongs_to :parent, class_name: "Comment", optional: true, counter_cache: :replies_count
  has_many :replies, -> { order(likes_count: :desc, replies_count: :desc, created_at: :desc) }, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  validates :body, presence: true

  scope :top_level, -> { where(parent_id: nil) }
  scope :reply_level, -> { where.not(parent_id: nil) }

  scope :by_likes, -> { order(likes_count: :desc, created_at: :asc) }

  def top_level?
    parent_id.nil?
  end
end
