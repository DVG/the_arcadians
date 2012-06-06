FactoryGirl.define do
  sequence :title do |n|
    "Forum #{n}"
  end
  factory :forum do
    title
    description "My Description"
  end
end