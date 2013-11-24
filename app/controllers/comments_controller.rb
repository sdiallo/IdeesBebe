class CommentsController < ApplicationController

  load_and_authorize_resource :product, find_by: :slug, id_param: :product_id
  load_and_authorize_resource :comment, only: :destroy

  def create
    comment = comments_params.merge(user_id: current_user.id)
    @product.comments.create(comment)
    redirect_to product_path(@product.slug)
  end

  def destroy
    @comment.destroy
    redirect_to product_path(@product.slug)
  end

  private

    def comments_params
      params.require(:comment).permit(:content)
    end
end
