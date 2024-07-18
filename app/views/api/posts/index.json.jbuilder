json.array!(@output.posts) do |post|
  json.code post.code
  json.avatar_data post.avatar_data
  json.name post.name
  json.tags post.tags
  json.content post.content
end
