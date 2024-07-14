json.post do
  json.avatar_url @output.post_detail.avatar_url
  json.name @output.post_detail.name
  json.tags @output.post_detail.tags
  json.content @output.post_detail.content
end
