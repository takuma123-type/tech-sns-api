class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

# Rails.application.routes.draw do
#   namespace :admin do
#     draw :admin
#   end
# end


Rails.application.routes.draw do
  namespace :api do
    draw :api
  end
end