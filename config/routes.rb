TheArcadians::Application.routes.draw do
  devise_for :users
  resources :forums, :only => [:index, :show] do
    resources :posts, :except => [:index]
  end
  root :to => 'forums#index'
end
