require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:admin_user) { create(:user, role: 'admin') }
  let(:regular_user) { create(:user, role: 'user') }

  before { sign_in admin_user }

  describe 'GET #index' do
    before { get :index }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:users)).to match_array([admin_user, regular_user]) }
  end

  describe 'GET #show' do
    context 'when the current user is an admin' do
      before { get :show, params: { id: regular_user.id } }

      it { is_expected.to respond_with(:success) }
      it { expect(assigns(:user)).to eq(regular_user) }
    end

    context 'when the current user is the same as the requested user' do
      before do
        sign_out admin_user
        sign_in regular_user
        get :show, params: { id: regular_user.id }
      end

      it { is_expected.to respond_with(:success) }
      it { expect(assigns(:user)).to eq(regular_user) }
    end

    context 'when the current user is not the requested user and not an admin' do
      before do
        sign_out admin_user
        sign_in regular_user
        get :show, params: { id: admin_user.id }
      end

      it 'redirects to the edit page' do
        expect(response).to redirect_to(edit_user_path)
      end
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: regular_user.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:user)).to eq(regular_user) }
  end

  describe 'PATCH #update' do
    let(:new_attributes) do
      { role: 'admin' }
    end

    let(:invalid_attributes) do
      { role: nil }
    end

    context 'with valid parameters' do
      before { patch :update, params: { id: regular_user.id, user: new_attributes } }

      it 'updates the user and redirects to the user show page' do
        expect(regular_user.reload.role).to eq('admin')
        expect(response).to redirect_to(user_path(regular_user))
      end

      it { expect(flash[:notice]).to eq('Profile updated successfully.') }
    end
  end

  describe 'DELETE #destroy' do
    let!(:user_to_destroy) { create(:user) }

    context 'when the user is successfully deleted' do
      it 'destroys the user and redirects to users index with notice' do
        expect do
          delete :destroy, params: { id: user_to_destroy.id }
        end.to change(User, :count).by(-1)

        expect(response).to redirect_to(users_path)
        expect(flash[:notice]).to eq('User was successfully deleted.')
      end
    end

    context 'when the user cannot be deleted' do
      before do
        allow_any_instance_of(User).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: user_to_destroy.id }
      end

      it 'redirects to users index with alert' do
        expect(response).to redirect_to(users_path)
        expect(flash[:alert]).to eq('Error deleting user.')
      end
    end
  end
end
