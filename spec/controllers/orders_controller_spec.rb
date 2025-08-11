require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:user) { create(:user) }
  let(:order) { create(:order, user:) }

  describe 'GET #index' do
    before { get :index }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:orders)).to eq([order]) }
  end

  describe 'GET #show' do
    before { get :show, params: { id: order.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:order)).to eq(order) }
  end

  describe 'GET #new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:order)).to be_a_new(Order) }
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        order_date: Date.today,
        total_amount: 100.0,
        user_id: user.id,
        shipping_address: '123 Test St',
        status: 'pending',
        shipping_status: 'not_shipped'
      }
    end

    let(:invalid_attributes) do
      {
        order_date: nil,
        total_amount: -10.0,
        user_id: nil,
        shipping_address: '',
        status: nil,
        shipping_status: nil
      }
    end

    context 'with valid parameters' do
      it 'creates a new Order and redirects to the created order' do
        expect do
          post :create, params: { order: valid_attributes }
        end.to change(Order, :count).by(1)

        created_order = Order.last
        expect(response).to redirect_to(order_path(created_order))
      end
    end

    context 'with invalid parameters' do
      before { post :create, params: { order: invalid_attributes } }

      it { is_expected.to render_template(:new) }
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) do
      { shipping_address: '456 New St' }
    end

    let(:invalid_attributes) do
      { shipping_address: '' }
    end

    context 'with valid parameters' do
      before { patch :update, params: { id: order.id, order: new_attributes } }

      it { is_expected.to redirect_to(order) }
      it { expect(order.reload.shipping_address).to eq('456 New St') }
    end

    context 'with invalid parameters' do
      before { patch :update, params: { id: order.id, order: invalid_attributes } }

      it { is_expected.to render_template(:edit) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:order_to_destroy) { create(:order, user:) }

    it 'destroys the requested order and redirects to orders_url' do
      expect do
        delete :destroy, params: { id: order_to_destroy.id }
      end.to change(Order, :count).by(-1)

      expect(response).to redirect_to(orders_url)
    end
  end
end
