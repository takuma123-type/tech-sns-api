resources :posts, only: [:index, :create, :show], param: :code do
end

resources :sessions, only: [] do
  collection do
    post :sign_up
    post :log_in
    put :update_profile
  end
end