class ProductsController < ApplicationController
  load_and_authorize_resource except: %i[index show]
  before_action :set_product, only: %i[show edit update destroy delete_image]

  def index
    search
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
    if params[:product][:images].present?
      params[:product][:images].each do |image|
        @product.images.attach(image)
      end
    end

    if @product.update(product_params.except(:images))
      redirect_to @product, notice: I18n.t('products.update.success')
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_url, notice: I18n.t('products.destroy.success')
  end

  def delete_image
    @product.images.find(params[:image_id]).purge
    redirect_to edit_product_path(@product), notice: I18n.t('products.images.delete_success')
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity, :SKU, category_ids: [], images: [])
  end

  def search
    @pagy, @products = if params[:q].present?
                         pagy(Product.where('name ILIKE ?', "%#{params[:q]}%"))
                       else
                         pagy(Product.all)
                       end
  end
end
