class ProductCategory < ActiveRecord::Base

  validates :name, presence: true, uniqueness: { case_sensitive: false } 
  has_many  :products
  has_one   :product_category_info

end
