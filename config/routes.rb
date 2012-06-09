TheArcadians::Application.routes.draw do
  devise_for :users
  resources :forums, :only => [:index, :show] do
    resources :posts, :except => [:index] do
      member do
        get 'view_thread'
      end
    end
  end
  root :to => 'forums#index'
end
