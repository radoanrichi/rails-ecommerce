class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_one :cart_item, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one :order_item

  has_one_attached :image

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :stock_quantity, presence: true
  validates :SKU,
            allow_blank: true,
            length: { in: 8..12 },
            format: { with: /\A[A-Z0-9]+\z/, message: 'only allows uppercase letters and numbers' },
            uniqueness: true
end
