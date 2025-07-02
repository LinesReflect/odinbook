class Post < ApplicationRecord
  belongs_to :poster, class_name: "User"
  has_many :likes, dependent: :destroy

  validates :body, presence: true
end
