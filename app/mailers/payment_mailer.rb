class PaymentMailer < ApplicationMailer
  def payment_confirmation(order)
    @order = order
    @user = @order.user
    mail(to: @user.email, subject: 'Payment Confirmation')
  end
end
