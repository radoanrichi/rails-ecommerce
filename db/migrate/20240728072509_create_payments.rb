class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true, index: { unique: true }
      t.integer :payment_method, null: false
      t.integer :payment_status, null: false
      t.date :payment_date, null: false

      t.timestamps
    end
  end
end
