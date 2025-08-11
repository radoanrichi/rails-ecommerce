require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe 'validations' do
    context 'with valid attributes' do
      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when name is missing' do
      it 'is not valid without a name' do
        subject.name = nil
        expect(subject).not_to be_valid
      end
    end

    context 'when email is missing' do
      it 'is not valid without an email' do
        subject.email = nil
        expect(subject).not_to be_valid
      end
    end

    context 'when phone number is invalid' do
      it 'is not valid without a phone number' do
        subject.phone = nil
        expect(subject).not_to be_valid
      end
    end

    context 'when phone number is valid' do
      it 'is valid with a valid phone number' do
        subject.phone = '+8801712345678'
        expect(subject).to be_valid
      end
    end
  end

  describe 'callbacks' do
    context 'before saving' do
      it 'normalizes the phone number' do
        user = build(:user)
        expect(user).to receive(:normalize_phone_number)
        user.save
      end
    end
  end

  describe 'methods' do
    context '#normalize_phone_number' do
      it 'normalizes the phone number correctly' do
        user = create(:user, phone: '+8801712345678')
        expect(user.phone).to eq(PhonyRails.normalize_number('+8801712345678', default_country_code: 'BD'))
      end
    end
  end
end
