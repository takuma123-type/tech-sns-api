json.user do
  json.code @output.user_detail[:code]
  json.avatar_url @output.user_detail[:avatar_url]
  json.name @output.user_detail[:name]
  json.description @output.user_detail[:description]
end
