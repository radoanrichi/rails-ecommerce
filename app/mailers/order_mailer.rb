class OrderMailer < ApplicationMailer
  default from: 'orders@wellshopping.io'

  def order_confirmation(order)
    @order = order
    @user = @order.user
    @url  = 'http://localhost:3000'
    mail(to: @user.email, subject: I18n.t('order_mailer.order_confirmation.subject', order_id: @order.id))
  end
end
