class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.decimal :balance, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
