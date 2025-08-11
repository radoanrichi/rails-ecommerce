require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let(:review) { create(:review, product:, user:) }

  describe 'POST #create' do
    let(:valid_attributes) { attributes_for(:review, user_id: user.id, product_id: product.id) }
    let(:invalid_attributes) { attributes_for(:review, user_id: nil, product_id: product.id) }

    context 'with valid attributes' do
      it 'creates a new review and redirects to the product' do
        expect do
          post :create, params: { product_id: product.id, review: valid_attributes }
        end.to change(Review, :count).by(1)

        expect(response).to redirect_to(product)
      end
    end

    context 'with invalid attributes' do
      before { post :create, params: { product_id: product.id, review: invalid_attributes } }

      it { is_expected.to render_template(:new) }
    end
  end
end
