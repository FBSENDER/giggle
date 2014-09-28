class ProductsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :find_product, only: :show

  def index
    @products = Product.order(sort_column + " " + sort_direction).classify_published(params)
    @product_categories = ProductCategory.all
    @current_category = @product_categories.where(:id => params[:category].to_i).first
    if sort_column == "id" && sort_direction == "asc"
      @related_products = Product.published.order("published_at desc").limit(3)
    end
    if !@current_category.nil?
      @links = []
      amazon_products_count = AmazonProduct.count
      category_id = params[:category].to_i
      10.times do |time_0|
        10.times do |time_1|
          page = (category_id - 1) * 10 + time_0 * 100 + time_1
          break if page * 100 > amazon_products_count
          idiom = Idiom.where(:level => 1, :page => page).first
          text = idiom.nil? ? '空气净化器' : "空气净化器_#{idiom.keyword}"
          url = "/amazon_products?level=1&page=#{page}"
          @links << {:text => text, :url => url}
        end
      end
    end
  end

  def show
    @evaluates = @product.evaluates.order(id: :desc).limit(3)
    @message = @product.messages.build
    @per_page = Message.per_page
    params[:page] = @product.last_page_with_per_page(@per_page) if params[:page].blank?
    @messages = @product.messages.paginate(page: params[:page], per_page: @per_page)
    @likeable = Likeship.likeable(@product)  
    @related_products = Product.where("published_at is not null and id >= ?",@product.id).limit(3)
  end

  private

    def find_product
      @product = Product.find(params[:id])
    end

    def sort_column
      Product.column_names.include?(params[:sort]) ? params[:sort] : "id"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
