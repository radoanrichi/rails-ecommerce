class OrdersController < ApplicationController
  before_action :set_order, only: %i[show edit update destroy]

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to @order, notice: I18n.t('orders.create.success')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: I18n.t('orders.update.success')
    else
      render :edit
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: I18n.t('orders.destroy.success')
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:order_date, :total_amount, :user_id, :status, :shipping_address, :shipping_status)
  end
end
