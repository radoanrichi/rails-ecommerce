class CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[edit update destroy]
  before_action :set_cart, only: %i[create]

  def create
    product_id = params[:cart_item][:product_id]
    quantity = params[:cart_item][:quantity].to_i

    if current_user
      @cart = current_user.cart
      existing_cart_item = @cart.cart_items.find_by(product_id:)
    else
      @cart = Cart.find_by(id: session[:cart_id]) || Cart.create
      session[:cart_id] = @cart.id
      existing_cart_item = @cart.cart_items.find_by(product_id:)
    end

    @product = Product.find(product_id)

    if @product.stock_quantity < quantity
      redirect_back fallback_location: root_path, alert: I18n.t('cart_items.create.insufficient_stock')
      return
    end

    ActiveRecord::Base.transaction do
      if existing_cart_item
        existing_cart_item.update!(quantity: existing_cart_item.quantity + quantity)
      else
        @cart.cart_items.create!(cart_item_params)
      end

      @cart.update!(item_count: @cart.cart_items.sum(:quantity))
    end

    if current_user
      redirect_to user_cart_path(current_user), notice: I18n.t('cart_items.create.success')
    else
      redirect_to root_path, notice: I18n.t('cart_items.create.success')
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound
    redirect_back fallback_location: root_path, alert: I18n.t('cart_items.create.error')
  end

  def edit
  end

  def update
    if @cart_item.update(cart_item_params)
      redirect_to cart_path(@cart_item.cart.user), notice: I18n.t('cart_items.update.success')
    else
      render :edit
    end
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    quantity = @cart_item.quantity
    product = @cart_item.product

    ActiveRecord::Base.transaction do
      @cart_item.destroy!

      product.update!(stock_quantity: product.stock_quantity + quantity)

      if current_user
        @cart = current_user.cart
        @cart.update!(item_count: @cart.cart_items.sum(:quantity))
        redirect_to user_cart_path(current_user), notice: I18n.t('cart_items.destroy.success')
      else
        @cart = Cart.find(session[:cart_id])
        @cart.update!(item_count: @cart.cart_items.sum(:quantity))
        redirect_to cart_path(@cart), notice: I18n.t('cart_items.destroy.success')
      end
    end
  rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid
    redirect_back fallback_location: root_path, alert: I18n.t('cart_items.destroy.error')
  end

  private

  def set_cart
    @cart = if current_user
              current_user.cart
            else
              Cart.find(session[:cart_id])
            end
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end
