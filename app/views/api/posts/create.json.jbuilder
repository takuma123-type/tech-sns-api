json.results do
  json.code @output.post.id
  json.content @output.post.content
  json.tags @output.post.tags.map(&:name)
end
