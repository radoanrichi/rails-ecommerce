require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { build(:product) }

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:categories) }
    it { is_expected.to have_one(:cart_item) }
    it { is_expected.to have_many(:reviews) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a description' do
      subject.description = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a price' do
      subject.price = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a stock_quantity' do
      subject.stock_quantity = nil
      expect(subject).to_not be_valid
    end

    it 'is valid with a blank SKU' do
      subject.SKU = ''
      expect(subject).to be_valid
    end

    it 'is not valid with a too short SKU' do
      subject.SKU = 'SHORT'
      expect(subject).to_not be_valid
    end

    it 'is not valid with a too long SKU' do
      subject.SKU = 'TOOLONGSKU12345'
      expect(subject).to_not be_valid
    end

    it 'is not valid with an invalid SKU format' do
      subject.SKU = 'invalid_sku!'
      expect(subject).to_not be_valid
    end

    it 'is valid with a correct SKU format' do
      subject.SKU = 'VALID123'
      expect(subject).to be_valid
    end

    it 'is not valid with a duplicate SKU' do
      create(:product, SKU: subject.SKU)
      expect(subject).to_not be_valid
    end
  end
end
