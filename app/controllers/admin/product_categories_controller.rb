class Admin::ProductCategoriesController < Admin::BaseController
  before_action :find_product_category, only: [:show, :edit, :update, :destroy, :all]

  def index
    @product_categories = ProductCategory.paginate(page: params[:page])
  end

  def show
    @products = @product_category.products
  end

  def new
    @product_category = ProductCategory.new
    @product_category.product_category_info = ProductCategoryInfo.new
  end

  def create
    @product_category = ProductCategory.new(product_category_params)
    category_info = ProductCategoryInfo.new(info_params)
    if @product_category.save
      category_info.product_category_id = @product_category.id
      category_info.save
      flash[:success] = '创建成功！'
      redirect_to admin_product_categories_path
    else
      flash.now[:danger] = '创建失败，请重新创建！'
      render 'new'
    end
  end

  def edit
    if @product_category.product_category_info.nil?
      @product_category.product_category_info = ProductCategoryInfo.new
      @product_category.product_category_info.product_category_id = @product_category.id
    end
  end

  def update
    if @product_category.update(product_category_params)
      @product_category.product_category_info.update(info_params)
      flash[:success] = '更新成功！'
      redirect_to admin_product_categories_path
    else
      flash.now[:danger] = '更新失败，请重新更新！'
      render 'edit'
    end
  end

  def destroy
    @product_category.product_category_info.destroy if @product_category.product_category_info
    @product_category.destroy
    @product_categories = ProductCategory.paginate(page: params[:page])
    flash[:success] = '删除成功！'
    if @product_categories.blank?
      redirect_to admin_product_categories_path
    else
      redirect_to :back
    end
  end

  private
    def product_category_params
      params.require(:product_category).permit(:name)
    end

    def info_params
      params.require(:product_category_info).permit(:details)
    end

    def find_product_category
      @product_category = ProductCategory.find(params[:id])
    end
end
