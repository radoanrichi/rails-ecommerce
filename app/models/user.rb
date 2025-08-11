class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :reviews, dependent: :destroy

  enum role: %i[admin user].freeze

  has_secure_password

  EMAIL_REGEX = /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: EMAIL_REGEX }
  validates :address, presence: true
  validates :phone, presence: true, phony_plausible: true

  before_save :normalize_phone_number
  after_create :create_cart

  private

  def normalize_phone_number
    self.phone = PhonyRails.normalize_number(phone, default_country_code: 'BD')
  end

  def create_cart
    Cart.create(user: self) # Create a cart for the newly created user
  end
end
