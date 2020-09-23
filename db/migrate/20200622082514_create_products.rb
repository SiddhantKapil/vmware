class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.decimal :price, precision: 8, scale: 2
      t.string :primary_category
      t.string :seconday_category
      t.string :model_number
      t.string :upc
      t.string :sku
    end
  end
end
