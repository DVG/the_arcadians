TheArcadians::Application.routes.draw do
  devise_for :users
  resources :forums, :only => [:index, :show] do
    resources :discussions, :only => [:index, :new, :create]
  end
  resources :discussions, :except => [:index, :new, :create] do
    resources :posts, :except => [:show]
  end
  resources :posts, :only => [:show]
  root :to => 'forums#index'
end
