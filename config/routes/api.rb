resources :posts, only: [:index, :create] do
end

post 'sessions', to: 'sessions#create'