require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'validations' do
    let(:order) { create(:order) }
    let(:product) { create(:product) }

    it 'is valid with valid attributes' do
      order_item = build(:order_item, order:, product:, quantity: 2, price: 15.99)
      expect(order_item).to be_valid
    end

    it 'is not valid without an order_id' do
      order_item = build(:order_item, order: nil)
      expect(order_item).to_not be_valid
      expect(order_item.errors[:order]).to include('must exist')
    end

    it 'is not valid without a product_id' do
      order_item = build(:order_item, product: nil)
      expect(order_item).to_not be_valid
      expect(order_item.errors[:product]).to include('must exist')
    end

    it 'is not valid with a non-unique product within the same order' do
      order = create(:order)
      product = create(:product)
      create(:order_item, order:, product:, quantity: 2)
      order_item = build(:order_item, order:, product:, quantity: 3)
      expect(order_item).to_not be_valid
      expect(order_item.errors[:product_id]).to include('has already been taken')
    end

    it 'is not valid without a quantity' do
      order_item = build(:order_item, quantity: nil)
      expect(order_item).to_not be_valid
      expect(order_item.errors[:quantity]).to include("can't be blank")
    end

    it 'is not valid with a quantity less than 1' do
      order_item = build(:order_item, quantity: 0)
      expect(order_item).to_not be_valid
      expect(order_item.errors[:quantity]).to include('must be greater than or equal to 1')
    end

    it 'is not valid without a price' do
      order_item = build(:order_item, price: nil)
      expect(order_item).to_not be_valid
      expect(order_item.errors[:price]).to include("can't be blank")
    end

    it 'is not valid with a negative price' do
      order_item = build(:order_item, price: -1)
      expect(order_item).to_not be_valid
      expect(order_item.errors[:price]).to include('must be greater than or equal to 0')
    end
  end
end
