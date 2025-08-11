class CreateCategoriesProductsJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :categories_products, id: false do |t|
      t.belongs_to :category
      t.belongs_to :product
    end

    add_index :categories_products, %i[category_id product_id], unique: true
  end
end
