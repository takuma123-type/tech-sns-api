class Models::PostCell
  include ActiveModel::Model

  attr_accessor :code, :avatar_url, :name, :tags, :content
end
