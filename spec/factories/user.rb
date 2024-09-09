FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    address { '123 Test St' }
    phone { '+8801712345678' }
    role { :user }

    trait :admin do
      role { :admin }
    end
  end
end
