require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    context 'with valid attributes' do
      it 'is valid' do
        order = build(:order)
        expect(order).to be_valid
      end
    end

    context 'when order_date is missing' do
      it 'is not valid without an order_date' do
        order = build(:order, order_date: nil)
        expect(order).to_not be_valid
        expect(order.errors[:order_date]).to include("can't be blank")
      end
    end

    context 'when total_amount is missing or invalid' do
      it 'is not valid without a total_amount' do
        order = build(:order, total_amount: nil)
        expect(order).to_not be_valid
        expect(order.errors[:total_amount]).to include("can't be blank")
      end

      it 'is not valid with a negative total_amount' do
        order = build(:order, total_amount: -1)
        expect(order).to_not be_valid
        expect(order.errors[:total_amount]).to include('must be greater than or equal to 0')
      end
    end

    context 'when shipping_address is missing' do
      it 'is not valid without a shipping_address' do
        order = build(:order, shipping_address: nil)
        expect(order).to_not be_valid
        expect(order.errors[:shipping_address]).to include("can't be blank")
      end
    end
  end

  describe 'enums' do
    context 'default values' do
      it 'defaults status to pending' do
        order = create(:order)
        expect(order.status).to eq('pending')
      end

      it 'defaults shipping_status to not_shipped' do
        order = create(:order)
        expect(order.shipping_status).to eq('not_shipped')
      end
    end
  end
end
