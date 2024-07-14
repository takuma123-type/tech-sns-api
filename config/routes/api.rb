resources :posts, only: [:index, :create] do
end

resources :sessions, only: [] do
  collection do
    post :sign_up
    post :log_in
    put :update_profile
  end
end