class OrderMailer < ApplicationMailer
  default from: 'orders@wellshopping.io'

  def order_confirmation(order)
    @order = order
    @user = @order.user
    mail(to: @user.email, subject: I18n.t('order_mailer.order_confirmation.subject', order_id: @order.id))
  end
end
