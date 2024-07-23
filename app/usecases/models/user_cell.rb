class Models::UserCell
  include ActiveModel::Model

  attr_accessor :id, :avatar_url, :name, :email, :created_at
end