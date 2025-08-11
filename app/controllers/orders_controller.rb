class OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :set_order, only: %i[show email_preview update destroy]

  def index
    @orders = if current_user.admin?
                Order.includes(:user).all
              else
                current_user.orders.includes(:order_items)
              end
  end

  def show
  end

  def email_preview
    @email_content = OrderMailer.order_confirmation(@order).body.raw_source.html_safe
  end

  def update
    authorize! :update, @order
    if @order.update(order_params)
      redirect_to order_path(@order), notice: I18n.t('orders.update.success')
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @order
    @order.destroy
    redirect_to orders_path, notice: I18n.t('orders.destroy.success')
  end

  private

  def set_order
    @order = if current_user.admin?
               Order.find(params[:id])
             else
               current_user.orders.find(params[:id])
             end
  rescue ActiveRecord::RecordNotFound
    redirect_to orders_path, alert: I18n.t('orders.show.not_found')
  end

  def order_params
    params.require(:order).permit(:status, :shipping_status)
  end
end
