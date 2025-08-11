class CartsController < ApplicationController
  before_action :set_user
  before_action :set_cart, only: %i[show edit update destroy]

  def create
    @cart = @user.build_cart(cart_params)
    @cart.item_count = 0

    if @cart.save
      redirect_to user_cart_path(@user), notice: I18n.t('carts.create.success')
    else
      render :new
    end
  end

  def show
    @cart_items = @cart.cart_items.includes(:product)
  end

  def edit
  end

  def update
    if @cart.update(cart_params)
      redirect_to user_cart_path(@user), notice: I18n.t('carts.update.success')
    else
      render :edit
    end
  end

  def destroy
    @cart.destroy
    redirect_to root_path, notice: I18n.t('carts.destroy.success')
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_cart
    @cart = @user.cart
  end

  def cart_params
    params.require(:cart).permit(:user_id, :item_count)
  end
end
