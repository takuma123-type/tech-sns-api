# app/views/posts/_post.json.jbuilder
json.code post.code
json.content post.content
json.tags post.tags.map(&:name)
