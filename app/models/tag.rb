class Tag < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  has_many :post_tags
  has_many :posts, through: :post_tags
end
