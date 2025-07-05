class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy

  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy

  validates :body, presence: true

  scope :top_level, -> { where(parent_id: nil) }
  scope :replies, -> { where.not(parent_id: nil) }
end
