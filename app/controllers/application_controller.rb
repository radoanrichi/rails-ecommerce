class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :call_custom_action, if: :user_signed_in?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name address phone role])
  end

  private

  def call_custom_action
    return unless session[:cart_id] && session[:cart_id] != current_user.cart.id

    session_cart = Cart.find(session[:cart_id])
    flash[:notice] = I18n.t('carts.merge.success') if merge_carts(current_user.cart, session_cart)
    session.delete(:cart_id)
  end

  def merge_carts(user_cart, session_cart)
    session_cart.cart_items.each do |item|
      existing_item = user_cart.cart_items.find_by(product_id: item.product_id)

      if existing_item
        existing_item.update(quantity: existing_item.quantity + item.quantity)
      else
        user_cart.cart_items.create(product_id: item.product_id, quantity: item.quantity)
      end
    end
    session_cart.destroy
    true
  end

  include Pagy::Backend
end
