class ProductsController < ApplicationController
  
  before_action :set_product
  before_filter :must_be_current_user, except: [:index, :show] 

  def index
  end
  # GET /products/1
  def show
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
    @product = Product.new(product_params)
    current_user.products << @product
    if @product.save
      redirect_to product_path(@product.slug), notice: 'Product was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to product_path(@product.slug), notice: 'Product was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to profile_path(current_user.slug)
  end

  private

    def set_product
      if params[:profile_id].blank?
        @product = Product.find_by_slug(params[:id])
        @product ||= Product.find(params[:id])
        @user = @product.user
      else 
        @user = current_user
      end
    end

    def product_params
      params.require(:product).permit(:name, :description)
    end
end
