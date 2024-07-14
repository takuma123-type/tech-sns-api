require 'bcrypt'
require 'securerandom'

class User < ApplicationRecord
  has_many :posts
  include BCrypt

  before_create :set_code

  def password=(new_password)
    self[:password] = Password.create(new_password)
  end

  def authenticate(password)
    Password.new(self[:password]) == password
  end

  def generate_jwt
    JWT.encode({ id: id, exp: 60.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end

  private

  def set_code
    self.code = SecureRandom.uuid
  end
end
