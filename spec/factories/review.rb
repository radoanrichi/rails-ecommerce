FactoryBot.define do
  factory :review do
    association :user
    association :product
    rating { 3 }
  end
end
