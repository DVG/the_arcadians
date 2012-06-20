authorization do
  role :admin do
    includes :guest
    has_permission_on [:posts, :discussions], to: [:create, :update, :delete]
  end
  role :moderator do
  end
  role :registered do
    includes :guest
    has_permission_on [:posts, :discussions], to: [:create]
    has_permission_on [:posts, :discussions], to: [:update, :delete] do
      if_attribute :user_id => is { user.id }
    end
  end
  role :jailed do
  end
  role :banned do
  end
  role :guest do
    has_permission_on [:forums, :posts, :discussions], to: :read
  end
end
privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read,   :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end