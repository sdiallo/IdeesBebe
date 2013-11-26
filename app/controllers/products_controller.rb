class ProductsController < ApplicationController
  
  before_action :set_product
  before_filter :must_be_current_user, except: [:index, :show] 

  def index
  end
  # GET /products/1
  def show
    @comment = Comment.new
  end

  # GET /profiles/:profile_id/products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /profiles/:profile_id/products
  def create
    if @product = current_user.products.create(product_params.except(:asset))
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
      else
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
    @product.destroy
    redirect_to products_path(@user.slug)
  end

  private

    def set_product
      if params[:profile_id].blank?
        @product = Product.find_by_slug(params[:id])
        @product ||= Product.find(params[:id])
        @user = @product.user
      elsif params[:action] == "index"
        @user = User.find_by_slug(params[:profile_id])
        @user ||= User.find(params[:profile_id])
      else 
        @user = current_user
      end
    end

    def product_params
      params.require(:product).permit(:name, :description, :asset)
    end
end
