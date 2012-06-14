FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end
  sequence :username do |u|
    "user_#{u}"
  end
  factory :user do
    email
    username
    password 'secret'
    password_confirmation { |u| u.password }
    role
  end
end