class UserMailer < ApplicationMailer
  default from: 'no-reply@wellshopping.io'

  def welcome_email(user)
    @user = user
    @url  = 'http://localhost:3000'
    mail(to: @user.email, subject: 'Welcome to WellShopping E-Commerce')
  end
end
