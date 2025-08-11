class Product < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :cart_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many_attached :images

  has_one_attached :image

  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :SKU,
            allow_blank: true,
            length: { in: 8..12 },
            format: { with: /\A[A-Z0-9]+\z/, message: :invalid_sku_format },
            uniqueness: true

  scope :available, -> { where('stock_quantity > 0') }
  scope :by_category, ->(category_id) { joins(:categories).where(categories: { id: category_id }) }
end
