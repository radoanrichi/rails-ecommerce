class CreateOrderItems < ActiveRecord::Migration[7.1]
  def change
    create_table :order_items do |t|
      t.references :order, null: false
      t.references :product, null: false
      t.integer :quantity, null: false
      t.float :price, null: false
      t.timestamps
    end
  end
end
