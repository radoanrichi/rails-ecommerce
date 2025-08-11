class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :rating, inclusion: { in: 1..5 }, presence: true
end
