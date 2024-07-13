require 'bcrypt'

class User < ApplicationRecord
  include BCrypt

  def password=(new_password)
    self[:password] = Password.create(new_password)
  end

  # パスワードの認証
  def authenticate(password)
    Password.new(self[:password]) == password
  end

  def generate_jwt
    JWT.encode({ id: id, exp: 60.days.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end
end
