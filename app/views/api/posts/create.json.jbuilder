# app/views/api/posts/create.json.jbuilder
json.results do
  json.code @output.code
  json.content @output.content
  json.tags @output.tags
end
