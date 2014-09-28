class AmazonProductsController < ApplicationController
  def index
    check_params
    @high_level_links = []
    @same_level_links = []
    @low_level_links = []
    @related_products = []
    if @level == 0
      @related_products = AmazonProduct.offset(@page * 10).limit(10)
      @high_level_links << build_link_top
      @high_level_links << build_link_level_2(0,@page)
      @high_level_links << build_link_level_0_1(1,@page / 10) 
      @high_level_links << build_link_level_0_1(0,@page) 
      @same_level_links << build_link_level_0_1(0,@page - 2) if @page - 2 >= 0
      @same_level_links << build_link_level_0_1(0,@page - 1) if @page - 1 >= 0
      @same_level_links << build_link_level_0_1(0,@page + 1) if @page + 1 <= @max_page_level_0
      @same_level_links << build_link_level_0_1(0,@page + 2) if @page + 2 <= @max_page_level_0
    elsif @level == 1
      @related_products = AmazonProduct.offset(@page * 100 + 10 * (Time.now.day % 10)).limit(10)
      @high_level_links << build_link_top
      @high_level_links << build_link_level_2(1,@page)
      @high_level_links << build_link_level_0_1(1,@page) 
      @same_level_links << build_link_level_0_1(1,@page - 2) if @page - 2 >= 0
      @same_level_links << build_link_level_0_1(1,@page - 1) if @page - 1 >= 0
      @same_level_links << build_link_level_0_1(1,@page + 1) if @page + 1 <= @max_page_level_1
      @same_level_links << build_link_level_0_1(1,@page + 2) if @page + 2 <= @max_page_level_1
      10.times do |time|
        @low_level_links << build_link_level_0_1(0,@page * 10 + time) 
      end
    end
  end
  def show
    id = params[:id]
    @product = AmazonProduct.find(id)
    @img_show = 1
    @related_products_1 = AmazonProduct.where("id > ?",id).limit(3)
    @related_products_2 = AmazonProduct.where("id < ?",id).limit(3)
    @links = []
    page_0 = id.to_i / 10
    page_1 = id.to_i / 100
    @links << build_link_top
    @links << build_link_level_2(0,page_0)
    @links << build_link_level_0_1(1,page_1)
    @links << build_link_level_0_1(0,page_0)
  end

  private

  def check_params
    if params[:level] != "1" && params[:level] != "0"
      raise ActionController::RoutingError.new("not found")
    end
    if !params[:page].present?
      raise ActionController::RoutingError.new("not found")
    end
    @level = params[:level].to_i
    @page = params[:page].to_i
    products_count = AmazonProduct.count
    @max_page_level_0 = (products_count / 10).ceil
    @max_page_level_1 = (products_count / 100).ceil
    if @level == 0 && (@page < 0 || @page > @max_page_level_0)
      raise ActionController::RoutingError.new("not found")
    end
    if @level == 1 && (@page < 0 || @page > @max_page_level_1)
      raise ActionController::RoutingError.new("not found")
    end
    @current_idiom = Idiom.where(:level => @level, :page => @page).first
  end

  def build_title_level_0_1(level,page)
    idiom = Idiom.where(:level => level, :page => page).first
    return "空气净化器" if idiom.nil?
    "#{idiom.keyword}_空气净化器"
  end

  def build_title_level_2(level,page)
    category_id = (page / (10 ^ (level + 1)) + 1) % 10
    category = ProductCategory.where(:id => category_id).first
    return '空气净化器' if category.nil?
    category.name
  end

  def build_url_level_0_1(level,page)
    "/amazon_products?level=#{level}&page=#{page}"
  end

  def build_url_level_2(level,page)
    category_id = (page / (10 ^ (level + 1)) + 1) % 10
    category = ProductCategory.where(:id => category_id).first
    return 'http://air.vxixi.com' if category.nil?
    "/products?category_id=#{category_id}"
  end

  def build_link_top
    {:text => "空气净化器", :url => "http://air.vxixi.com"}
  end
  def build_link_level_0_1(level,page)
    {:text => build_title_level_0_1(level,page), :url => build_url_level_0_1(level,page)}
  end
  def build_link_level_2(level,page)
    {:text => build_title_level_2(level,page), :url => build_url_level_2(level,page)}
  end
end
