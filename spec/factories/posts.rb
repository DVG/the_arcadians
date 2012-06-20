FactoryGirl.define do
  factory :post do
    body "My Body"
    user
    discussion
  end
end