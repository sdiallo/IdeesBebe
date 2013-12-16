class ProductsController < ApplicationController
  
  load_resource :user, find_by: :slug, id_param: :profile_id, only: [:index, :new]
  load_and_authorize_resource :product, find_by: :slug, shallow: true, except: [:index, :by_category, :update, :create, :destroy]

  load_and_authorize_resource :product, find_by: :id, shallow: true, only: [:update, :destroy]

  before_action lambda { authorized_upload(product_params[:asset]) if product_params[:asset].present? }, only: [:create, :update]

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
    raise CanCan::AccessDenied.new("Not authorized!") if @user != current_user
  end

  # GET /products/1/edit
  def edit
  end

  # POST /profiles/:profile_id/products
  def create
    @product = current_user.products.build(product_params.except(:asset))
    if @product.save
      @product.assets.create(file: product_params[:asset]) if product_params[:asset].present?
      redirect_to product_path(@product.slug), notice: I18n.t('product.create.success')
    else
      render action: :new
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params.except(:asset))
      if @product.has_maximum_upload?
        return redirect_to action: :edit, alert: I18n.t('product.update.too_many_assets')
      end
      @product.assets.create(file: product_params[:asset]) if product_params[:asset].present?
      redirect_to edit_product_path(@product.slug), notice: I18n.t('product.update.success')
    else
      render action: :edit
    end
  end

  # DELETE /products/1
  def destroy
    @user = @product.user
    if @product.destroy
      flash[:notice] = I18n.t('product.destroy.success')
    else
      flash[:alert] = I18n.t('product.destroy.error')
    end
    redirect_to products_path(@user.slug)
  end

  private

    def product_params
      params.require(:product).permit(:name, :description, :asset, :category_id)
    end
end
