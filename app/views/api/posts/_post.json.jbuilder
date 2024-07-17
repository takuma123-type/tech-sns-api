json.code post.code
json.content post.content
json.tags post.tags.map(&:name)
json.user do
  json.name post.user.name
  json.avatar_data Base64.encode64(post.user.avatar_data) if post.user.avatar_data.present?
  json.description post.user.description
end
