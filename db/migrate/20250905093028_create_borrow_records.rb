class CreateBorrowRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :borrow_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book_item, null: false, foreign_key: true
      t.boolean :returned, default: false
      t.datetime :borrow_date
      t.datetime :return_date
      t.decimal :fee, precision: 10, scale: 2

      t.timestamps
    end
  end
end
