class Post < ApplicationRecord
  has_many :post_tags
  has_many :tags, through: :post_tags

  before_create :generate_code

  private

  def generate_code
    self.code = SecureRandom.uuid
  end
end
