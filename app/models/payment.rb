class Payment < ApplicationRecord
  belongs_to :order

  enum payment_method: %i[credit_card mobile_banking bank_transfer cash_on_delivery].freeze
  enum payment_status: %i[pending completed failed].freeze

  validates :order_id, presence: true, uniqueness: true
  validates :payment_method, presence: true
  validates :payment_status, presence: true
  validates :payment_date, presence: true
end
