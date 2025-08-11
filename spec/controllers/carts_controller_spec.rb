require 'rails_helper'

RSpec.describe CartsController, type: :controller do
  let(:user) { create(:user) }
  let(:cart) { user.cart }

  context 'when user is logged in' do
    before do
      sign_in user
    end

    describe 'GET #show' do
      it 'assigns the requested cart to @cart' do
        get :show
        expect(assigns(:cart)).to eq(cart)
      end

      it 'assigns cart items to @cart_items' do
        get :show
        expect(assigns(:cart_items)).to eq(cart.cart_items)
      end
    end

    describe 'POST #create' do
      it 'does not create a new cart if one already exists' do
        expect do
          post :create, params: { cart: { item_count: 0 } }
        end.to_not change(Cart, :count)
      end
    end

    describe 'PATCH #update' do
      it 'updates the cart item count' do
        patch :update, params: { id: cart.id, cart: { item_count: 10 } }
        cart.reload
        expect(cart.item_count).to eq(10)
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the cart' do
        expect do
          delete :destroy, params: { id: cart.id }
        end.to change(Cart, :count).by(-1)
      end
    end
  end

  context 'when user is not logged in' do
    describe 'GET #show' do
      it 'assigns the cart to @cart' do
        get :show
        expect(assigns(:cart)).to be_present
      end

      it 'assigns cart items to @cart_items' do
        get :show
        expect(assigns(:cart_items)).to eq(Cart.find(session[:cart_id]).cart_items)
      end
    end

    describe 'POST #create' do
      it 'creates a new cart' do
        expect do
          post :create, params: { cart: { item_count: 0 } }
        end.to change(Cart, :count).by(1)
      end
    end
  end
end
