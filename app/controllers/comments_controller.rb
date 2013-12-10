class CommentsController < ApplicationController

  load_and_authorize_resource :product, find_by: :slug, id_param: :product_id, only: :create
  load_and_authorize_resource :comment, only: :destroy

  def create
    @product.comments.build(comments_params.merge(user_id: current_user.id))
    if @product.save
      flash[:notice] = I18n.t('comment.create.success')
    else
      flash[:alert] = I18n.t('comment.create.error')
    end
    redirect_to product_path(@product.slug)
  end

  def destroy
    if @comment.destroy
      flash[:notice] = I18n.t('comment.destroy.success')
    else
      flash[:alert] = I18n.t('comment.destroy.error')
    end
    redirect_to product_path(@comment.product.slug)
  end

  private

    def comments_params
      params.require(:comment).permit(:content)
    end
end
