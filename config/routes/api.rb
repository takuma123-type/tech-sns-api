resources :posts, only: [:index, :create, :show], param: :code do
  collection do
    get 'generate_signed_url'
  end
end

resources :tags, only: [:index]

resources :users, only: [:show, :update], param: :code do
  put 'update_profile', on: :collection
end

resources :sessions, only: [] do
  collection do
    post :sign_up
    post :log_in
    put :update_profile
    delete :log_out
  end
end

mount ActionCable.server => '/cable'