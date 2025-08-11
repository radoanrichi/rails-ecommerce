require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #index' do
    before { get :index }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:users)).to eq([user]) }
  end

  describe 'GET #show' do
    before { get :show, params: { id: user.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:user)).to eq(user) }
  end

  describe 'GET #new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:user)).to be_a_new(User) }
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: user.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:user)).to eq(user) }
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      { name: 'Test User', email: 'test@example.com', password: 'password', address: '123 Test St',
        phone: '+8801234567890' }
    end

    let(:invalid_attributes) do
      { name: '', email: '', password: '', address: '', phone: '' }
    end

    context 'with valid parameters' do
      it 'creates a new User and redirects to the created user' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)

        created_user = User.last
        expect(response).to redirect_to(user_path(created_user))
      end
    end

    context 'with invalid parameters' do
      before { post :create, params: { user: invalid_attributes } }

      it { is_expected.to render_template(:new) }
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) do
      { name: 'Updated User' }
    end

    let(:invalid_attributes) do
      { name: '' }
    end

    context 'with valid parameters' do
      before { patch :update, params: { id: user.id, user: new_attributes } }

      it { is_expected.to redirect_to(user) }
      it { expect(user.reload.name).to eq('Updated User') }
    end

    context 'with invalid parameters' do
      before { patch :update, params: { id: user.id, user: invalid_attributes } }

      it { is_expected.to render_template(:edit) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:user_to_destroy) { create(:user) }

    it 'destroys the requested user and redirects to users_url' do
      expect do
        delete :destroy, params: { id: user_to_destroy.id }
      end.to change(User, :count).by(-1)

      expect(response).to redirect_to(users_url)
    end
  end
end
