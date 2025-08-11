require 'rails_helper'

RSpec.describe CartItemsController, type: :controller do
  let(:product) { create(:product, stock_quantity: 10) }
  let(:user) { create(:user) }
  let(:cart) { create(:cart, user:) }
  let(:cart_item) { create(:cart_item, cart:, product:, quantity: 2) }

  before do
    sign_in user if user
  end

  describe 'POST #create' do
    context 'when a cart exists' do
      it 'increases the cart item quantity if the item already exists' do
        post :create, params: { cart_item: { product_id: product.id, quantity: 2 } }
        expect(cart.cart_items.find_by(product:).quantity).to eq(4)
      end

      it 'redirects back with an error if there is insufficient stock' do
        product.update!(stock_quantity: 1)
        post :create, params: { cart_item: { product_id: product.id, quantity: 5 } }
        expect(response).to redirect_back(fallback_location: root_path)
        expect(flash[:alert]).to eq(I18n.t('cart_items.create.insufficient_stock'))
      end

      it 'does not adjust the product stock quantity' do
        expect do
          post :create, params: { cart_item: { product_id: product.id, quantity: 2 } }
        end.not_to(change { product.reload.stock_quantity })
      end
    end

    context 'when no cart exists' do
      it 'creates a new cart and adds the item to the cart' do
        post :create, params: { cart_item: { product_id: product.id, quantity: 2 } }
        expect(Cart.count).to eq(1)
        expect(Cart.first.cart_items.count).to eq(1)
      end
    end
  end

  describe 'PATCH #update' do
    it 'updates the cart item quantity' do
      patch :update, params: { id: cart_item.id, cart_item: { quantity: 3 } }
      expect(cart_item.reload.quantity).to eq(3)
      expect(response).to redirect_to(cart_path(cart_item.cart.user))
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the cart item and updates the cart item count' do
      expect do
        delete :destroy, params: { id: cart_item.id }
      end.to change(CartItem, :count).by(-1)
      expect(cart.cart_items.count).to eq(0)
      expect(response).to redirect_to(user_cart_path(user))
    end

    it 'does not adjust the product stock quantity' do
      expect do
        delete :destroy, params: { id: cart_item.id }
      end.not_to(change { product.reload.stock_quantity })
    end

    it 'redirects back with an error if the record is not found' do
      delete :destroy, params: { id: 'non-existent-id' }
      expect(response).to redirect_back(fallback_location: root_path)
      expect(flash[:alert]).to eq(I18n.t('cart_items.destroy.error'))
    end
  end
end
