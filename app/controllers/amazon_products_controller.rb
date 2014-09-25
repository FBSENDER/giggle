class AmazonProductsController < ApplicationController
  def index
  end
  def show
    id = params[:id] || 1
    @product = AmazonProduct.find(id)
    @img_show = 1
    @related_products_1 = AmazonProduct.where("id > ?",id).limit(3)
    @related_products_2 = AmazonProduct.where("id < ?",id).limit(3)
  end
end
