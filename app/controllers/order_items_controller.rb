class OrderItemsController < ApplicationController
  load_and_authorize_resource
  before_action :set_order_item, only: %i[edit update destroy]

  def edit
  end

  def update
    if @order_item.update(order_item_params)
      redirect_to order_path(@order_item.order), notice: I18n.t('order_items.update.success')
    else
      render :edit
    end
  end

  def destroy
    @order_item.destroy
    redirect_to order_path(@order_item.order), notice: I18n.t('order_items.destroy.success')
  end

  private

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def order_item_params
    params.require(:order_item).permit(:product_id, :quantity, :price)
  end
end
