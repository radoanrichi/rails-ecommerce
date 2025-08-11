class CartsController < ApplicationController
  before_action :set_cart, only: %i[show edit update destroy checkout]

  def create
    @cart = Cart.new(cart_params)
    session[:cart_id] = @cart.id if @cart.save

    if @cart.save
      redirect_to cart_path, notice: I18n.t('carts.create.success')
    else
      render :new
    end
  end

  def show
    @cart_items = @cart.cart_items.includes(:product)
  end

  def update
    @cart.update(cart_params)
  end

  def destroy
    @cart.destroy
    redirect_to root_path, notice: I18n.t('carts.destroy.success')
  end

  def checkout
    if current_user
      if session[:cart_id] && session[:cart_id] != current_user.cart.id
        merge_carts(current_user.cart, Cart.find(session[:cart_id]))
        session.delete(:cart_id)
      end

      result = CheckoutService.new(current_user, current_user.cart).call

      if result[:success]
        redirect_to order_path(result[:order]), notice: I18n.t('checkout.success')
      else
        redirect_to user_cart_path(current_user), alert: I18n.t('checkout.failed', error: result[:error])
      end
    else
      session[:checkout_redirect] = request.path
      redirect_to new_user_session_path, alert: I18n.t('checkout.sign_in_required')
    end
  end

  private

  def set_cart
    @cart = if current_user
              current_user.cart
            else
              Cart.find_by(id: session[:cart_id]) || Cart.create
            end
    session[:cart_id] ||= @cart.id unless current_user
  end

  def cart_params
    params.require(:cart).permit(:item_count)
  end
end
