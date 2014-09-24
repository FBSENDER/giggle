class AmazonProductsController < ApplicationController
  def index
  end
  def show
    id = params[:id] || 1
    @product = AmazonProduct.find(id)
    @img_show = 1
    @related_products = AmazonProduct.where("id > ?",id).limit(5)
  end
end
