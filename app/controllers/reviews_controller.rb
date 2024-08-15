class ReviewsController < ApplicationController
  before_action :set_product
  before_action :set_review, only: %i[show edit update destroy]

  def new
    @review = @product.reviews.build
  end

  def create
    @review = @product.reviews.build(review_params)
    @review.user = current_user
    if @review.save
      redirect_to @product, notice: 'Review was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to @review, notice: 'Review was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to @product, notice: 'Review was successfully destroyed.'
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_review
    @review = @product.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
