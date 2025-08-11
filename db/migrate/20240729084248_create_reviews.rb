class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false
      t.references :product, null: false
      t.integer :rating
      t.text :comment

      t.timestamps
    end
  end
end
