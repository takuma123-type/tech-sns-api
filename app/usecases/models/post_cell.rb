class Models::PostCell
	include ActiveModel::Model

	attr_accessor :code
	attr_accessor :content
	attr_accessor :tags
end