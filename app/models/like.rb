class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, counter_cache: :likes_count, polymorphic: true

  validates :user_id, uniqueness: { scope: [ :likeable_type, :likeable_id ] }
end
