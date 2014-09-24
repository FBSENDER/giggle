class CreateAmazonProducts < ActiveRecord::Migration
  def change
    create_table :amazon_products do |t|
      t.string  "asin"
      t.string  "title"
      t.column  :price, :decimal, precision: 10, scale: 2
      t.string  "url"
      t.string  "img_1"
      t.string  "img_2"
      t.string  "img_3"
      t.string  "brand"
      t.text    "features"
      t.text    "descriptions"
      t.string  "amazon_category_id"
      t.string  "amazon_category_name"
      t.datetime  "created_at"
      t.datetime  "updated_at"
    end
  end
end
