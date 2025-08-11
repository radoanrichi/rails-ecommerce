require 'rufus-scheduler'

if Rails.env.development? || Rails.env.production?
  scheduler = Rufus::Scheduler.singleton

  scheduler.cron '0 0 * * *' do
    Rails.logger.info 'Cleaning up inactive carts and old cart items...'

    Cart.where(user_id: nil).where('created_at < ?', 1.day.ago).find_each do |cart|
      Rails.logger.info "Deleting empty cart #{cart.id} created at #{cart.created_at}"
      cart.destroy
    end

    Cart.joins(:cart_items).where('cart_items.created_at < ?', 7.days.ago).find_each do |cart|
      cart.cart_items.each do |item|
        Rails.logger.info "Deleting old cart item #{item.id} from cart #{cart.id}"
        item.destroy
      end
      Rails.logger.info "Cleaned cart #{cart.id}"
    end
  end
end
