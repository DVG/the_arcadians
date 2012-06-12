TheArcadians::Application.routes.draw do
  resources :discussions

  devise_for :users
  resources :forums, :only => [:index, :show] do
    resources :discussions, :only => [:index, :new, :create]
  end
  resources :discussions, :except => [:index, :new, :create] do
    resources :posts, :only => [:index]
  end
  resources :posts
  root :to => 'forums#index'
end
