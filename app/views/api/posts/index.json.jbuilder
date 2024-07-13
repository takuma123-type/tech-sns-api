json.array!(@output.posts) do |post|
  json.avatar_url post.avatar_url
  json.name post.name
  json.tags post.tags
  json.content post.content
end
