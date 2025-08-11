FactoryBot.define do
  factory :product do
    name { 'Test Product' }
    description { 'This is a test product.' }
    price { 99.99 }
    stock_quantity { 10 }
    SKU { 'TESTSKU123' }
  end
end
