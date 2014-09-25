class ChangeAmazonProducts < ActiveRecord::Migration
  def up
    change_table :amazon_products do |t|
      t.change :url, :text
    end
  end

  def down
    change_table :amazon_products do |t|
      t.change :url, :string
    end
  end
end
