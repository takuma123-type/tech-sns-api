class Models::PostCell
  include ActiveModel::Model

  attr_accessor :avatar_url, :name, :tags, :content
end
