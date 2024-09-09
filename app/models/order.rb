class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_one :payment, dependent: :destroy

  enum status: %i[pending confirmed cancelled].freeze
  enum shipping_status: %i[not_shipped in_transit delivered].freeze

  validates :order_date, presence: true
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :shipping_address, presence: true

  def payment_status
    payment&.payment_status
  end

  def payment_method
    payment&.payment_method
  end
end
