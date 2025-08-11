FactoryBot.define do
  factory :cart do
    association :user
    item_count { 0 }
  end
end
