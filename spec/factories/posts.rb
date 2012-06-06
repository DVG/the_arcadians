FactoryGirl.define do
  factory :thread, :class => Post do
    title "My Post"
    body "My Body"
    user
    thread nil
    forum
    factory :reply, :class => Post do
      thread
    end
  end
  factory :post do
    title "My Post"
    body "My Body"
    user
    thread nil
    forum
  end
end