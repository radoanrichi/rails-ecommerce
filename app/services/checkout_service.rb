class CheckoutService
  def initialize(user, cart)
    @user = user
    @cart = cart
  end

  def call
    return empty_cart_error if cart_empty?

    ActiveRecord::Base.transaction do
      order = create_order
      create_order_items(order)
      create_payment(order)
      cart_items = @cart.cart_items
      cart_items.each do |item|
        item.destroy
      end
      { success: true, order: }
    end
  rescue StandardError => e
    { success: false, error: I18n.t('carts.checkout.order_creation_failed', error_message: e.message) }
  end

  private

  def cart_empty?
    @cart.cart_items.count.zero? || @cart.cart_items.count.nil?
  end

  def empty_cart_error
    { success: false, error: I18n.t('carts.checkout.empty_cart_error') }
  end

  def create_order
    @user.orders.create!(
      order_date: Date.today,
      total_amount:,
      shipping_address: @user.address
    )
  end

  def total_amount
    @cart.cart_items.sum { |item| item.product.price * item.quantity }
  end

  def create_order_items(order)
    @cart.cart_items.each do |cart_item|
      order.order_items.create!(
        product_id: cart_item.product_id,
        quantity: cart_item.quantity,
        price: cart_item.product.price
      )
    end
  end

  def create_payment(order)
    order.create_payment!(
      payment_method: :cash_on_delivery,
      payment_status: :pending,
      payment_date: Time.current
    )
  rescue StandardError => e
    raise I18n.t('carts.checkout.payment_creation_failed', error_message: e.message)
  end
end
