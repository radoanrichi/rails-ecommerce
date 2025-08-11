require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:order) { create(:order) }
  let(:payment) { create(:payment, order:) }

  describe 'GET #index' do
    before { get :index }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:payments)).to eq([payment]) }
  end

  describe 'GET #show' do
    before { get :show, params: { id: payment.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:payment)).to eq(payment) }
  end

  describe 'GET #new' do
    before { get :new, params: { order_id: order.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:payment)).to be_a_new(Payment) }
  end

  describe 'GET #edit' do
    before { get :edit, params: { order_id: order.id, id: payment.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:payment)).to eq(payment) }
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        order_id: order.id,
        payment_method: 'credit_card',
        payment_status: 'completed',
        payment_date: Date.today
      }
    end

    let(:invalid_attributes) do
      {
        order_id: order.id,
        payment_method: nil,
        payment_status: nil,
        payment_date: nil
      }
    end

    context 'with valid parameters' do
      it 'creates a new Payment' do
        expect do
          post :create, params: { order_id: order.id, payment: valid_attributes }
        end.to change(Payment, :count).by(1)

        expect(response).to redirect_to(order_path(order))
      end
    end

    context 'with invalid parameters' do
      before { post :create, params: { order_id: order.id, payment: invalid_attributes } }

      it { is_expected.to render_template(:new) }
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) do
      {
        payment_status: 'failed'
      }
    end

    let(:invalid_attributes) do
      {
        payment_status: nil
      }
    end

    context 'with valid parameters' do
      before { patch :update, params: { order_id: order.id, id: payment.id, payment: new_attributes } }

      it { is_expected.to redirect_to(order_path(order)) }
      it { expect(payment.reload.payment_status).to eq('failed') }
    end

    context 'with invalid parameters' do
      before { patch :update, params: { order_id: order.id, id: payment.id, payment: invalid_attributes } }

      it { is_expected.to render_template(:edit) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:payment_to_destroy) { create(:payment, order:) }

    it 'destroys the requested payment and redirects to the order' do
      expect do
        delete :destroy, params: { order_id: order.id, id: payment_to_destroy.id }
      end.to change(Payment, :count).by(-1)

      expect(response).to redirect_to(order_path(order))
    end
  end
end
