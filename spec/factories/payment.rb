FactoryBot.define do
  factory :payment do
    association :order
    payment_method { :credit_card }
    payment_status { :pending }
    payment_date { Date.today }
  end
end
