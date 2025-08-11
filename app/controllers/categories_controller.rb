class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = Category.all
  end

  def show
    @id = 4545
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to @category, notice: I18n.t('categories.create.success')
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: I18n.t('categories.update.success')
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: I18n.t('categories.destroy.success')
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
