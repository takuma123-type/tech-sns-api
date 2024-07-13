resources :posts, only: [:create] do
end

post 'sessions', to: 'sessions#create'