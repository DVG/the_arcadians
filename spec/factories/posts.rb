FactoryGirl.define do
  factory :post do
    title "My Post"
    body "My Body"
    user
    discussion
  end
end