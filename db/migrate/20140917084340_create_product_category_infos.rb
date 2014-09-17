class CreateProductCategoryInfos < ActiveRecord::Migration
  def change
    create_table :product_category_infos, force: true do |t|
      t.integer   "product_category_id"
      t.text      "details"
      t.datetime  "created_at"
      t.datetime  "updated_at"
    end
  end
end
