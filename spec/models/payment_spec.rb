require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'associations' do
    it 'belongs to an order' do
      should belong_to(:order)
    end
  end

  describe 'validations' do
    let(:order) { create(:order) }

    it 'is valid with valid attributes' do
      payment = build(:payment, order:, payment_method: :credit_card, payment_status: :pending,
                                payment_date: Date.today)
      expect(payment).to be_valid
    end

    it 'is not valid without an order' do
      payment = build(:payment, order: nil)
      expect(payment).to_not be_valid
      expect(payment.errors[:order]).to include('must exist')
    end

    it 'is not valid without a payment_method' do
      payment = build(:payment, payment_method: nil)
      expect(payment).to_not be_valid
      expect(payment.errors[:payment_method]).to include("can't be blank")
    end

    it 'is not valid without a payment_status' do
      payment = build(:payment, payment_status: nil)
      expect(payment).to_not be_valid
      expect(payment.errors[:payment_status]).to include("can't be blank")
    end

    it 'is not valid without a payment_date' do
      payment = build(:payment, payment_date: nil)
      expect(payment).to_not be_valid
      expect(payment.errors[:payment_date]).to include("can't be blank")
    end

    it 'is not valid with a non-unique order_id' do
      create(:payment, order:)
      duplicate_payment = build(:payment, order:)
      expect(duplicate_payment).to_not be_valid
      expect(duplicate_payment.errors[:order_id]).to include('has already been taken')
    end
  end
end
