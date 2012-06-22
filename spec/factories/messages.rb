# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    subject "MyString"
    body "MyText"
    sender
    recipient
    read false
  end
end
