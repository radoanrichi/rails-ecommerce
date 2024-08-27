class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :reviews, dependent: :destroy

  enum role: { admin: 0, user: 1 }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address, presence: true
  validates :phone, presence: true, phony_plausible: true

  before_save :normalize_phone_number
  after_create :create_cart
  after_create :create_order
  after_create :schedule_welcome_email

  private

  def normalize_phone_number
    self.phone = PhonyRails.normalize_number(phone, default_country_code: 'BD')
  end

  def create_cart
    Cart.create(user: self)
  end

  def create_order
    Order.create(user: self)
  end

  def schedule_welcome_email
    SendSignupEmailJob.set(wait: 1.minutes).perform_async(id)
  end
end
