class ProductsController < ApplicationController
  
  load_resource :user, find_by: :slug, id_param: :profile_id, only: [:index]
  load_and_authorize_resource :product, find_by: :slug, shallow: true, except: [:index, :by_category, :update, :create, :destroy]

  load_and_authorize_resource :product, find_by: :id, shallow: true, only: [:update, :destroy]


  def index
  end

  def by_category
    @category = Category.find_by_slug(params[:id])
    return redirect_to '/404.html' if @category.nil?
    @products = @category.all_products
  end
  # GET /products/1
  def show
    @comment = Comment.new
  end

  # GET /profiles/:profile_id/products/new
  def new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /profiles/:profile_id/products
  def create
    @product = current_user.products.create(product_params.except(:asset))
    unless @product.id.nil?
      unless product_params[:asset].nil?        
        Cloudinary::Uploader.upload(product_params[:asset])
        @product.assets.create(asset: product_params[:asset])
      end
      redirect_to product_path(@product.slug), notice: 'Product was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params.except(:asset))
      if @product.has_maximum_upload?
        flash[:notice] = "Maximum photos"
      elsif product_params[:asset].present?
        Cloudinary::Uploader.upload(product_params[:asset])
        @product.assets.create(asset: product_params[:asset])
      end
      flash[:notice] ||= 'Product was successfully updated.'
      redirect_to edit_product_path(@product.slug)
    else
      render action: 'edit'
    end
  end

  # DELETE /products/1
  def destroy
    @user = @product.user
    @product.destroy
    redirect_to products_path(@user.slug)
  end

  private

    def product_params
      params.require(:product).permit(:name, :description, :asset, :category_id)
    end
end
