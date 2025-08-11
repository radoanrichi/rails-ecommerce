require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:product) { create(:product) }

  describe 'GET #index' do
    before { get :index }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:products)).to eq([product]) }
  end

  describe 'GET #show' do
    before { get :show, params: { id: product.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:product)).to eq(product) }
  end

  describe 'GET #new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:product)).to be_a_new(Product) }
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: product.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:product)).to eq(product) }
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      { name: 'New Product', description: 'Product Description', price: 19.99, stock_quantity: 100, SKU: 'ABC12345' }
    end

    let(:invalid_attributes) do
      { name: '', description: '', price: nil, stock_quantity: nil, SKU: 'ABC' }
    end

    context 'with valid parameters' do
      it 'creates a new Product and redirects to the created product' do
        expect do
          post :create, params: { product: valid_attributes }
        end.to change(Product, :count).by(1)

        created_product = Product.last
        expect(response).to redirect_to(product_path(created_product))
        expect(flash[:notice]).to eq('Product was successfully created.')
      end
    end

    context 'with invalid parameters' do
      before { post :create, params: { product: invalid_attributes } }

      it { is_expected.to render_template(:new) }
      it { expect(assigns(:product)).to be_a_new(Product) }
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) do
      { name: 'Updated Product' }
    end

    let(:invalid_attributes) do
      { name: '' }
    end

    context 'with valid parameters' do
      before { patch :update, params: { id: product.id, product: new_attributes } }

      it { is_expected.to redirect_to(product) }
      it { expect(product.reload.name).to eq('Updated Product') }
    end

    context 'with invalid parameters' do
      before { patch :update, params: { id: product.id, product: invalid_attributes } }

      it { is_expected.to render_template(:edit) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:product_to_destroy) { create(:product) }

    it 'destroys the requested product and redirects to products_url' do
      expect do
        delete :destroy, params: { id: product_to_destroy.id }
      end.to change(Product, :count).by(-1)

      expect(response).to redirect_to(products_url)
    end
  end
end
