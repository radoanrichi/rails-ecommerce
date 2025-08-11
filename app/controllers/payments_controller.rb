class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[show edit update destroy]

  def index
    @payments = Payment.all
  end

  def show
  end

  def new
    @payment = Payment.new
  end

  def edit
  end

  def create
    @payment = Payment.new(payment_params)

    if @payment.save
      redirect_to @payment, notice: I18n.t('payments.create.success')
    else
      render :new
    end
  end

  def update
    if @payment.update(payment_params)
      redirect_to @payment, notice: I18n.t('payments.update.success')
    else
      render :edit
    end
  end

  def destroy
    @payment.destroy
    redirect_to payments_url, notice: I18n.t('payments.destroy.success')
  end

  private

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:order_id, :payment_method, :payment_status, :payment_date)
  end
end
