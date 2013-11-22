class CommentsController < ApplicationController

  before_action :set_product, only:  [:create]
  before_action :set_comment, only:  [:destroy]
  before_action :must_be_current_user

  def create
    comment = comments_params.merge(user_id: @user.id)
    @product.comments.create(comment)
    redirect_to product_path(@product.slug)
  end

  def destroy
    @comment.destroy
    redirect_to product_path(@product.slug)
  end

  private

    def set_product
      @product = Product.find(params[:product_id])
      @user = current_user
    end

    def set_comment
      @comment = Comment.find(params[:id])
      @product = @comment.product
      @user = @comment.user
    end

    def comments_params
      params.require(:comment).permit(:content)
    end
end
