require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:category) { create(:category) }

  describe 'GET #index' do
    before { get :index }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:categories)).to eq([category]) }
  end

  describe 'GET #show' do
    before { get :show, params: { id: category.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:category)).to eq(category) }
    it { expect(assigns(:id)).to eq(4545) }
  end

  describe 'GET #new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:category)).to be_a_new(Category) }
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: category.id } }

    it { is_expected.to respond_with(:success) }
    it { expect(assigns(:category)).to eq(category) }
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        { name: 'New Category', description: 'Category Description' }
      end

      it 'creates a new Category and redirects to the created category' do
        expect do
          post :create, params: { category: valid_attributes }
        end.to change(Category, :count).by(1)

        created_category = Category.last
        expect(response).to redirect_to(category_path(created_category))
        expect(flash[:notice]).to eq('Category was successfully created.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        { name: '', description: '' }
      end

      before { post :create, params: { category: invalid_attributes } }

      it { is_expected.to render_template(:new) }
      it { expect(assigns(:category)).to be_a_new(Category) }
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { name: 'Updated Category' }
      end

      before { patch :update, params: { id: category.id, category: new_attributes } }

      it { is_expected.to redirect_to(category) }
      it { expect(category.reload.name).to eq('Updated Category') }
      it { expect(flash[:notice]).to eq('Category was successfully updated.') }
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        { name: '' }
      end

      before { patch :update, params: { id: category.id, category: invalid_attributes } }

      it { is_expected.to render_template(:edit) }
    end
  end

  describe 'DELETE #destroy' do
    let!(:category_to_destroy) { create(:category) }

    it 'destroys the requested category and redirects to categories_url' do
      expect do
        delete :destroy, params: { id: category_to_destroy.id }
      end.to change(Category, :count).by(-1)

      expect(response).to redirect_to(categories_url)

      expect(flash[:notice]).to eq('Category was successfully destroyed.')
    end
  end
end
