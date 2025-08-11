class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: I18n.t('products.create.success')
    else
      render :new
    end
  end

  def update
    if @product.update(product_params)
      redirect_to @product, notice: I18n.t('products.update.success')
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: I18n.t('products.destroy.success')
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity, :SKU, category_ids: [], images: [])
  end
end
