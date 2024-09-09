class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy

  validates :item_count, numericality: { greater_than_or_equal_to: 0 }
end
