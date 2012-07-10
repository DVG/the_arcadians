TheArcadians::Application.routes.draw do
  devise_for :users
  namespace :user_control_panel do
    resources :messages, :except => [:edit, :update] do
      collection do
        get 'sent'
      end
    end
  end
  resources :forums, :only => [:index, :show] do
    resources :discussions, :only => [:index, :new, :create]
  end
  resources :discussions, :except => [:index, :new, :create] do
    resources :posts, :except => [:show]
  end
  resources :posts, :only => [:show] do
    member do
      get 'quote'
    end
  end
  root :to => 'forums#index'
end
