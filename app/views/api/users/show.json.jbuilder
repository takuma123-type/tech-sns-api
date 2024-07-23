json.user do
  json.avatar_data @output.user_detail.avatar_data
  json.name @output.user_detail.name
  json.tags @output.user_detail.tags
  json.content @output.user_detail.content
end
