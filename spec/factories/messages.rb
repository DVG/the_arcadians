# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :subject do |n|
    "MySubject #{n}"
  end
  factory :message do
    subject
    body "MyText"
    sender
    recipient
    read false
  end
end
