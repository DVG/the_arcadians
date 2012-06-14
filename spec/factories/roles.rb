# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :role do
    name "registered"
    factory :admin_role do
      name "admin"
    end
    factory :moderator_role do
      name "moderator"
    end
    factory :jailed_role do
      name "jailed"
    end
    factory :registered_role do
      name "registered"
    end
  end
end
