class ReviewsController < ApplicationController
  before_action :set_product
  before_action :set_review, only: %i[show edit update destroy]

  def create
    @review = @product.reviews.build(review_params)

    if @review.save
      redirect_to @product, notice: I18n.t('reviews.create.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_review
    @review = @product.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :user_id)
  end
end
