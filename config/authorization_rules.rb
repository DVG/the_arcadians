authorization do
  role :admin do
  end
  role :moderator do
  end
  role :registered do
  end
  role :jailed do
  end
  role :banned do
  end
  role :guest do
  end
end
privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read,   :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end