require 'rails_helper'

RSpec.describe CartItem, type: :model do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }

  context 'validations' do
    it 'is valid with valid attributes' do
      cart_item = build(:cart_item, cart:, product:, quantity: 1)
      expect(cart_item).to be_valid
    end

    it 'is not valid without a cart_id' do
      cart_item = build(:cart_item, cart: nil)

      expect(cart_item).to_not be_valid
      expect(cart_item.errors[:cart]).to include('must exist')
    end

    it 'is not valid without a product_id' do
      cart_item = build(:cart_item, product: nil)
      expect(cart_item).to_not be_valid
      expect(cart_item.errors[:product]).to include('must exist')
    end

    it 'is not valid without a quantity' do
      cart_item = build(:cart_item, quantity: nil)
      expect(cart_item).to_not be_valid
      expect(cart_item.errors[:quantity]).to include('is not a number')
    end

    it 'is not valid with a quantity less than 1' do
      cart_item = build(:cart_item, quantity: 0)
      expect(cart_item).to_not be_valid
      expect(cart_item.errors[:quantity]).to include('must be greater than or equal to 1')
    end

    it 'is not valid with a non-unique product within the same cart' do
      create(:cart_item, cart:, product:)
      duplicate_cart_item = build(:cart_item, cart:, product:)
      expect(duplicate_cart_item).to_not be_valid
      expect(duplicate_cart_item.errors[:product_id]).to include('has already been taken')
    end
  end
end
