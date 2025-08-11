require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validations' do
    let(:user) { create(:user) }
    let(:product) { create(:product) }

    context 'with valid attributes' do
      it 'is valid with valid attributes' do
        review = build(:review, user:, product:, rating: 4)
        expect(review).to be_valid
      end
    end

    context 'when user is missing' do
      it 'is not valid without a user' do
        review = build(:review, user: nil)
        expect(review).to_not be_valid
        expect(review.errors[:user]).to include('must exist')
      end
    end

    context 'when product is missing' do
      it 'is not valid without a product' do
        review = build(:review, product: nil)
        expect(review).to_not be_valid
        expect(review.errors[:product]).to include('must exist')
      end
    end

    context 'when rating is invalid' do
      it 'is not valid without a rating' do
        review = build(:review, rating: nil)
        expect(review).to_not be_valid
        expect(review.errors[:rating]).to include("can't be blank")
      end

      it 'is not valid with a rating less than 1' do
        review = build(:review, rating: 0)
        expect(review).to_not be_valid
        expect(review.errors[:rating]).to include('is not included in the list')
      end

      it 'is not valid with a rating greater than 5' do
        review = build(:review, rating: 6)
        expect(review).to_not be_valid
        expect(review.errors[:rating]).to include('is not included in the list')
      end
    end
  end
end
