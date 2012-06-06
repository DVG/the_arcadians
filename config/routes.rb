TheArcadians::Application.routes.draw do
  devise_for :users
  resources :forums
  resources :posts
  root :to => 'forums#index'
end
