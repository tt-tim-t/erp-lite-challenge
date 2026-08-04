FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@erp-lite.test" }
    name { "Test User" }
    role { "merchandiser" }

    User::ROLES.each do |role_name|
      trait(role_name.to_sym) { role { role_name } }
    end
  end
end
