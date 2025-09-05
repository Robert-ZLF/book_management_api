class CreateBookItems < ActiveRecord::Migration[7.2]
  def change
    create_table :book_items do |t|
      t.string :title
      t.integer :stock_quantity
      t.integer :borrow_count

      t.timestamps
    end
  end
end
