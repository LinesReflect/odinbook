class Post < ApplicationRecord
  belongs_to :poster, class_name: "User"

  validates :body, presence: true
end
