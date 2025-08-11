FactoryBot.define do
  factory :user do
    name { 'Test User' }
    email { 'test@example.com' }
    password { 'password' }
    address { '123 Test St' }
    phone { '+8801712345678' }
    role { :user }
  end
end
