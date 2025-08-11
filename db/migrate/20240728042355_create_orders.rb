class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.date :order_date
      t.float :total_amount
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0
      t.text :shipping_address
      t.integer :shipping_status, default: 0

      t.timestamps
    end
  end
end
