class CommentsController < ApplicationController

  before_action :set_product
  before_action :must_be_current_user

  def create
    comment = comments_params.merge(user_id: @user.id)
    @product.comments.create(comment)
    redirect_to product_path(@product.slug)
  end

  private
    def set_product
      @product = Product.find(params[:product_id])
      @user = current_user
    end

    def comments_params
      params.require(:comment).permit(:content)
    end
end
