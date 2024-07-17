class Models::PostCreateCell
  include ActiveModel::Model

  attr_accessor :code
  attr_accessor :content
  attr_accessor :tags
  attr_accessor :user
end
