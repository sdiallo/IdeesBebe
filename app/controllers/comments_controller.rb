class CommentsController < ApplicationController

  load_and_authorize_resource :product, find_by: :slug, id_param: :product_id, only: :create
  load_and_authorize_resource :comment, only: :destroy

  def create
    comment = comments_params.merge(user_id: current_user.id)
    if @product.comments.create(comment)
      flash[:notice] = "Votre commentaire a bien été ajouté"
    else
      flash[:error] = "Une erreur s'est produite"
    end
    redirect_to product_path(@product.slug)
  end

  def destroy
    if @comment.destroy
      flash[:notice] = "Votre commentaire a bien été supprimé"
    else
      flash[:error] = "Une erreur s'est produite"
    end
    redirect_to product_path(@comment.product.slug)
  end

  private

    def comments_params
      params.require(:comment).permit(:content)
    end
end
