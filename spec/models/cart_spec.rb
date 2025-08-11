require 'rails_helper'

RSpec.describe Cart, type: :model do
  it 'is valid with valid attributes' do
    user = create(:user)
    cart = build(:cart, user:)
    expect(cart).to be_valid
  end

  it 'is not valid without a user' do
    cart = build(:cart, user: nil)
    expect(cart).not_to be_valid
    expect(cart.errors[:user]).to include('must exist')
  end

  it 'is not valid without an item_count' do
    cart = build(:cart, item_count: nil)
    expect(cart).not_to be_valid
    expect(cart.errors[:item_count]).to include("can't be blank")
  end

  it 'is not valid with a negative item_count' do
    cart = build(:cart, item_count: -1)
    expect(cart).not_to be_valid
    expect(cart.errors[:item_count]).to include('must be greater than or equal to 0')
  end
end
