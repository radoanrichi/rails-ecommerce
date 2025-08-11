FactoryBot.define do
  factory :order do
    association :user

    order_date { Date.today }
    total_amount { 100.0 }
    shipping_address { '123 Main Street, Anytown, Bangladesh' }
    status { :pending }
    shipping_status { :not_shipped }
  end
end
