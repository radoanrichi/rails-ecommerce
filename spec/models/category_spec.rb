require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'has and belongs to many products' do
    expect(subject).to have_and_belong_to_many(:products)
  end

  it 'validates presence of name' do
    expect(subject).to validate_presence_of(:name)
  end

  it 'validates presence of description' do
    expect(subject).to validate_presence_of(:description)
  end

  it 'is valid with valid attributes' do
    expect(build(:category)).to be_valid
  end

  it 'is not valid without a name' do
    expect(build(:category, name: nil)).to_not be_valid
  end

  it 'is not valid without a description' do
    expect(build(:category, description: nil)).to_not be_valid
  end
end
